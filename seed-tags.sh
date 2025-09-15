#!/bin/bash

# Script to seed the tags table with sample data
# Usage: ./seed-tags.sh

set -e

DB_FILE="dev.db"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Seeding tags table in $DB_FILE..."

# Check if database file exists
if [ ! -f "$SCRIPT_DIR/$DB_FILE" ]; then
    echo "Error: Database file $DB_FILE not found in $SCRIPT_DIR"
    exit 1
fi

# Sample tags to insert
TAGS=(
    "javascript"
    "react"
    "nodejs"
    "python"
    "java"
    "spring-boot"
    "web-development"
    "backend"
    "frontend"
    "database"
    "api"
    "tutorial"
    "programming"
    "software-engineering"
    "technology"
)

# Function to generate UUID-like string
generate_id() {
    echo "$(uuidgen 2>/dev/null || openssl rand -hex 16 | sed 's/\(..\)/\1-/g; s/-$//')"
}

# Insert tags into database
for tag in "${TAGS[@]}"; do
    id=$(generate_id)
    echo "Inserting tag: $tag (ID: $id)"
    
    sqlite3 "$SCRIPT_DIR/$DB_FILE" "INSERT OR IGNORE INTO tags (id, name) VALUES ('$id', '$tag');"
done

echo "✅ Tags seeding completed!"

# Show current tags count
count=$(sqlite3 "$SCRIPT_DIR/$DB_FILE" "SELECT COUNT(*) FROM tags;")
echo "Total tags in database: $count"

# Show some sample tags
echo "Sample tags:"
sqlite3 "$SCRIPT_DIR/$DB_FILE" "SELECT name FROM tags LIMIT 5;" | while read -r tag_name; do
    echo "  - $tag_name"
done