#!/bin/bash
# LLLM Stop Script
# Stops Open WebUI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Stopping Open WebUI..."
docker compose down

echo "Done."
echo "Note: llama-swap stops when you press Ctrl+C in its terminal."
