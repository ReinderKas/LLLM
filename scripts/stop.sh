#!/bin/bash
# LLLM Stop Script
# Stops all Docker containers (Open WebUI, n8n, Datasette)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "Stopping Docker containers..."
docker compose down

echo "Done."
echo "Note: llama-swap stops when you press Ctrl+C in its terminal."
