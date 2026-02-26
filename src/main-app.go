package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"log"
	"net"
	"net/http"
	"os"

	"cloud.google.com/go/cloudsqlconn"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/stdlib"
)

var db *sql.DB

func getEnv(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}

func main() {
	ctx := context.Background()

	// Cloud SQL connection using connector with IAM authentication
	d, err := cloudsqlconn.NewDialer(
		ctx,
		cloudsqlconn.WithIAMAuthN(),
		cloudsqlconn.WithDefaultDialOptions(
			cloudsqlconn.WithPrivateIP(),
		),
	)
	if err != nil {
		log.Fatal(err)
	}
	defer d.Close()

	// IAM authentication - no password needed
	dsn := "user=" + getEnv("DB_USER", "") +
		" dbname=" + getEnv("DB_NAME", "") +
		" sslmode=disable"

	config, err := pgx.ParseConfig(dsn)
	if err != nil {
		log.Fatal(err)
	}

	instanceConnectionName := getEnv("INSTANCE_CONNECTION_NAME", "")
	config.DialFunc = func(ctx context.Context, network, instance string) (net.Conn, error) {
		return d.Dial(ctx, instanceConnectionName)
	}

	db = stdlib.OpenDB(*config)
	defer db.Close()

	if err = db.Ping(); err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/query", queryHandler)

	port := getEnv("PORT", "8080")
	log.Printf("Server starting on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func queryHandler(w http.ResponseWriter, r *http.Request) {
	query := getEnv("DB_QUERY", "SELECT version()")

	rows, err := db.Query(query)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	cols, _ := rows.Columns()
	results := []map[string]interface{}{}

	for rows.Next() {
		row := make([]interface{}, len(cols))
		rowPtrs := make([]interface{}, len(cols))
		for i := range row {
			rowPtrs[i] = &row[i]
		}

		if err := rows.Scan(rowPtrs...); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		rowMap := make(map[string]interface{})
		for i, col := range cols {
			rowMap[col] = row[i]
		}
		results = append(results, rowMap)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(results)
}
