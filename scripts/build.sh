#!/bin/bash
set -e

# LLLM Build Script
# Builds llama.cpp, llama-swap server, and llama-swap UI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# Detect CPU cores
if [[ "$OSTYPE" == "darwin"* ]]; then
    CORES=$(sysctl -n hw.ncpu)
else
    CORES=$(nproc)
fi

echo "Building LLLM..."
echo "Using $CORES CPU cores"
echo ""

# Build llama.cpp
echo "[1/3] Building llama.cpp..."
cmake -B llama.cpp/build -S llama.cpp
cmake --build llama.cpp/build --config Release -j "$CORES"
echo "    Done"
echo ""

# Build llama-swap server
echo "[2/3] Building llama-swap server..."
mkdir -p llama-swap/build
go build -C llama-swap -o build/llama-swap .
echo "    Done"
echo ""

# Build llama-swap UI
echo "[3/4] Building llama-swap UI..."
npm --prefix llama-swap/ui install --silent
npm --prefix llama-swap/ui run build --silent
echo "    Done"
echo ""

# Initialize SQLite database for news aggregator
echo "[4/4] Initializing news aggregator database..."
DB_PATH="$PROJECT_ROOT/data/news_aggregator.db"
SCHEMA_PATH="$PROJECT_ROOT/n8n-workflows/schema.sql"

mkdir -p "$PROJECT_ROOT/data"

if [ ! -f "$DB_PATH" ]; then
    if [ -f "$SCHEMA_PATH" ]; then
        sqlite3 "$DB_PATH" < "$SCHEMA_PATH"
        echo "    Created database at $DB_PATH"
    else
        echo "    Warning: Schema file not found at $SCHEMA_PATH"
        echo "    Database not created"
    fi
else
    echo "    Database already exists at $DB_PATH"
fi
echo "    Done"
echo ""

echo "Build complete!"
echo ""
echo "Prerequisites for running:"
echo "    - Docker Desktop (for Open WebUI)"
echo "    - Models in ./models/ (run ./scripts/download-models.sh)"
echo ""
echo "Services available after running ./scripts/run.sh:"
echo "    - llama-swap:  http://localhost:8080"
echo "    - Datasette:   http://localhost:8001 (News API)"
echo "    - Open WebUI:  http://localhost:3000"
echo "    - n8n:         http://localhost:5678"
echo ""
echo "Run ./scripts/run.sh to start everything"
