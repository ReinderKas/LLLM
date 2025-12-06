# LLLM - Local Large Language Models

A complete local LLM stack for macOS with chat UI, workflow automation, and news aggregation.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Your Mac                                │
├─────────────────────────────────────────────────────────────────┤
│  llama-swap (native)         │  Docker                         │
│  ├── llama.cpp server        │  ├── Open WebUI (Chat UI)       │
│  └── Model management        │  ├── n8n (Workflow automation)  │
│      Port 8080               │  └── Datasette (SQLite API)     │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

```sh
# 1. Build everything
./scripts/build.sh

# 2. Download models (interactive)
./scripts/download-models.sh

# 3. Start all services
./scripts/run.sh

# 4. Stop all services
./scripts/stop.sh
```

## Services

| Service | URL | Description |
|---------|-----|-------------|
| **Open WebUI** | http://localhost:3000 | Chat interface with RAG, memory, web search |
| **llama-swap** | http://localhost:8080 | LLM proxy with auto model loading |
| **n8n** | http://localhost:5678 | Workflow automation (admin/changeme) |
| **Datasette** | http://localhost:8001 | SQLite REST API for news data |

## Features

- **Local LLMs**: Run Llama, Qwen, Mistral, DeepSeek, and more
- **Chat UI**: Full-featured interface with conversation history
- **News Aggregator**: Automated workflows fetch and summarize news via LLM
- **REST API**: OpenAI-compatible API at `/v1/chat/completions`

## Setup

### Prerequisites

- macOS (Apple Silicon recommended) with ~16GB RAM
- Docker Desktop
- Build tools: `brew install cmake go node`

### Installation

```sh
git clone --recursive https://github.com/YourUsername/LLLM.git && cd LLLM
./scripts/build.sh          # Build llama.cpp, llama-swap, UI
./scripts/download-models.sh # Download models (interactive)
./scripts/run.sh            # Start all services
```

## Connect from External Device

```sh
# Get your Mac's IP
ipconfig getifaddr en0

# Access from another device on the same network
http://<your-ip>:3000
```

## Project Structure

```
LLLM/
├── config.yaml          # llama-swap model configuration
├── docker-compose.yml   # Docker services config
├── scripts/
│   ├── build.sh         # Build llama.cpp, llama-swap, UI
│   ├── run.sh           # Start all services
│   ├── stop.sh          # Stop Docker containers
│   └── download-models.sh
├── llama.cpp/           # LLM inference engine (submodule)
├── llama-swap/          # Model proxy server (submodule)
├── models/              # GGUF model files
├── data/                # SQLite database
└── n8n-workflows/       # Automation workflows
```