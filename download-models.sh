#!/bin/bash
# Download script for recommended GGUF models
# For MacBook Pro M4 with 24GB RAM

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="$SCRIPT_DIR/models"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

cd "$MODELS_DIR"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  GGUF Model Downloader${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# All models from the recommendations
models=(
    # TOP PICKS
    "bartowski/Qwen2.5-14B-Instruct-GGUF|Qwen2.5-14B-Instruct-Q4_K_M.gguf|~9GB|Top Pick - General purpose"
    "bartowski/Meta-Llama-3.1-8B-Instruct-GGUF|Meta-Llama-3.1-8B-Instruct-Q8_0.gguf|~8.5GB|Top Pick - Full 8-bit precision"
    "bartowski/Mistral-Nemo-Instruct-2407-GGUF|Mistral-Nemo-Instruct-2407-Q5_K_M.gguf|~9GB|Top Pick - Fast chat"
    "bartowski/DeepSeek-Coder-V2-Lite-Instruct-GGUF|DeepSeek-Coder-V2-Lite-Instruct-Q4_K_M.gguf|~10GB|Top Pick - Coding"
    
    # REASONING & COMPLEX TASKS
    "bartowski/Qwen2.5-14B-Instruct-GGUF|Qwen2.5-14B-Instruct-Q5_K_M.gguf|~11GB|Reasoning - Higher quality"
    "bartowski/phi-4-GGUF|phi-4-Q4_K_M.gguf|~9GB|Reasoning - Microsoft's latest"
    "bartowski/gemma-2-27b-it-GGUF|gemma-2-27b-it-Q3_K_M.gguf|~13GB|Reasoning - Largest model"
    
    # CODING SPECIALISTS
    "bartowski/Qwen2.5-Coder-14B-Instruct-GGUF|Qwen2.5-Coder-14B-Instruct-Q4_K_M.gguf|~9GB|Coding - Top coding model"
    "TheBloke/CodeLlama-34B-Instruct-GGUF|codellama-34b-instruct.Q3_K_M.gguf|~15GB|Coding - Large & powerful"
    "TheBloke/deepseek-coder-6.7B-instruct-GGUF|deepseek-coder-6.7b-instruct.Q8_0.gguf|~7GB|Coding - Fast"
    
    # FAST & LIGHTWEIGHT
    "bartowski/Llama-3.2-3B-Instruct-GGUF|Llama-3.2-3B-Instruct-Q8_0.gguf|~3.5GB|Fast - Very quick responses"
    "bartowski/Phi-3.5-mini-instruct-GGUF|Phi-3.5-mini-instruct-Q8_0.gguf|~4GB|Fast - Lightweight tasks"
)

# Display menu
echo -e "${GREEN}Available models to download:${NC}"
echo ""
i=1
for entry in "${models[@]}"; do
    IFS='|' read -r repo file size desc <<< "$entry"
    printf "  ${YELLOW}[%2d]${NC} %-50s ${GREEN}%s${NC} - %s\n" "$i" "$file" "$size" "$desc"
    ((i++))
done
echo ""
echo -e "  ${YELLOW}[A]${NC}  Download ALL models (~100GB total)"
echo -e "  ${YELLOW}[Q]${NC}  Quit"
echo ""

download_model() {
    local repo="$1"
    local file="$2"
    local size="$3"
    local desc="$4"
    
    if [ -f "$MODELS_DIR/$file" ]; then
        echo -e "${YELLOW}Skipping $file (already exists)${NC}"
        return
    fi
    
    echo -e "${GREEN}Downloading: $file ($size)${NC}"
    echo -e "${BLUE}$desc${NC}"
    
    # Build the URL: https://huggingface.co/{repo}/resolve/main/{file}
    local url="https://huggingface.co/${repo}/resolve/main/${file}"
    
    # Download with curl, showing progress
    if curl -L --progress-bar -o "$file" "$url"; then
        echo -e "${GREEN}Downloaded successfully${NC}"
    else
        echo -e "${RED}Failed to download $file${NC}"
        rm -f "$file"  # Clean up partial download
    fi
    echo ""
}

echo -n "Enter your choice (comma-separated numbers, A for all, or Q to quit): "
read -r choice

if [[ "$choice" =~ ^[Qq]$ ]]; then
    echo "Goodbye!"
    exit 0
fi

if [[ "$choice" =~ ^[Aa]$ ]]; then
    echo ""
    echo -e "${GREEN}Downloading ALL models...${NC}"
    echo ""
    for entry in "${models[@]}"; do
        IFS='|' read -r repo file size desc <<< "$entry"
        download_model "$repo" "$file" "$size" "$desc"
    done
else
    # Parse comma-separated numbers
    IFS=',' read -ra selections <<< "$choice"
    for sel in "${selections[@]}"; do
        sel=$(echo "$sel" | tr -d ' ')
        if [[ "$sel" =~ ^[0-9]+$ ]] && [ "$sel" -ge 1 ] && [ "$sel" -le "${#models[@]}" ]; then
            entry="${models[$((sel-1))]}"
            IFS='|' read -r repo file size desc <<< "$entry"
            download_model "$repo" "$file" "$size" "$desc"
        else
            echo -e "${YELLOW}Invalid selection: $sel${NC}"
        fi
    done
fi

echo ""
echo -e "${GREEN}Done!${NC}"
echo -e "Models are in: ${BLUE}$MODELS_DIR${NC}"
echo ""
echo "To use a model, run:"
echo -e "  ${YELLOW}./start-server.sh${NC}  (interactive selection)"
echo -e "  ${YELLOW}MODEL_NAME=<filename> docker compose up${NC}  (Docker)"
