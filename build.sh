#!/bin/bash
set -e

# LLLM Build Script
# Builds llama.cpp, llama-swap server, and llama-swap UI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

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
echo "[3/3] Building llama-swap UI..."
npm --prefix llama-swap/ui install --silent
npm --prefix llama-swap/ui run build --silent
echo "    Done"
echo ""

echo "Build complete!"
echo "   Run ./run.sh to start the server"
