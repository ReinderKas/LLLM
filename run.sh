#!/bin/bash
set -e

# LLLM Run Script
# Starts llama-swap and Open WebUI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PORT="${1:-8080}"
CONFIG="${2:-config.yaml}"

# Check if llama-swap is built
if [[ ! -f "llama-swap/build/llama-swap" ]]; then
    echo "Error: llama-swap not built. Run ./build.sh first."
    exit 1
fi

# Check if llama-server is built
if [[ ! -f "llama.cpp/build/bin/llama-server" ]]; then
    echo "Error: llama.cpp not built. Run ./build.sh first."
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

# Start Open WebUI in Docker (if Docker is available)
if docker info > /dev/null 2>&1; then
    echo "Starting Open WebUI..."
    docker compose up -d
    echo "    Open WebUI: http://localhost:3000"
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

# Handle Ctrl+C to stop both services
trap 'echo ""; echo "Stopping services..."; docker compose down 2>/dev/null; exit 0' INT

./llama-swap/build/llama-swap --config "$CONFIG" --listen ":$PORT"
