#!/bin/bash
set -e

# LLLM Run Script
# Starts llama-swap and Open WebUI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

PORT="${1:-8080}"
CONFIG="${2:-config.yaml}"

# Check if llama-swap is built
if [[ ! -f "llama-swap/build/llama-swap" ]]; then
    echo "Error: llama-swap not built. Run ./scripts/build.sh first."
    exit 1
fi

# Check if llama-server is built
if [[ ! -f "llama.cpp/build/bin/llama-server" ]]; then
    echo "Error: llama.cpp not built. Run ./scripts/build.sh first."
    exit 1
fi

# Check if config exists
if [[ ! -f "$CONFIG" ]]; then
    echo "Error: Config file not found: $CONFIG"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Warning: Docker is not running. Open WebUI will not start."
    echo "         Start Docker Desktop to enable the full UI."
    echo ""
fi

# Start Docker services (if Docker is available)
if docker info > /dev/null 2>&1; then
    echo "Starting Docker services..."
    docker compose up -d --build
    echo "    Open WebUI:  http://localhost:3000"
    echo "    n8n:         http://localhost:5678 (admin/changeme)"
    echo "    Datasette:   http://localhost:8001 (News API)"
    echo "    News JSON:   http://localhost:8001/news_aggregator/news_items.json"
    echo ""
fi

echo "Starting llama-swap..."
echo "    Config: $CONFIG"
echo "    Port:   $PORT"
echo "    Dashboard: http://localhost:$PORT/ui/"
echo "    API:       http://localhost:$PORT/v1/chat/completions"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Handle Ctrl+C to stop all services
cleanup() {
    echo ""
    echo "Stopping services..."
    docker compose down 2>/dev/null
    exit 0
}
trap cleanup INT

./llama-swap/build/llama-swap --config "$CONFIG" --listen ":$PORT"
