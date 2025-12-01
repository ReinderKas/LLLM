# LLLM Setup Guide

Complete setup instructions for running local LLMs with llama.cpp and llama-swap.

---

## 1. Prerequisites

### Required Software
| Tool | Version | Purpose |
|------|---------|---------|
| Git | - | Clone repo with submodules |
| CMake | 3.14+ | Build llama.cpp |
| C++ Compiler | C++17 | Compile llama.cpp |
| Go | 1.21+ | Build llama-swap server |
| Node.js | 18+ | Build llama-swap UI |
| npm | - | Install UI dependencies |

### macOS Installation
```sh
brew install cmake go node
```

### Linux (Ubuntu/Debian)
```sh
sudo apt update
sudo apt install build-essential cmake golang-go nodejs npm
```

---

## 2. Clone Repository

```sh
git clone --recursive https://github.com/YourUsername/LLLM.git
cd LLLM
```

If you already cloned without `--recursive`:
```sh
git submodule update --init --recursive
```

---

## 3. Build Everything

All commands are run from the repository root (`LLLM/`).

### 3.1 Build llama.cpp
```sh
cmake -B llama.cpp/build -S llama.cpp
cmake --build llama.cpp/build --config Release -j $(sysctl -n hw.ncpu)
```

> On Linux, replace `$(sysctl -n hw.ncpu)` with `$(nproc)`

### 3.2 Build llama-swap Server
```sh
mkdir -p llama-swap/build
go build -C llama-swap -o build/llama-swap .
```

### 3.3 Build llama-swap UI
```sh
npm --prefix llama-swap/ui install
npm --prefix llama-swap/ui run build
```

### Build All (One-liner)
```sh
cmake -B llama.cpp/build -S llama.cpp && \
cmake --build llama.cpp/build --config Release -j $(sysctl -n hw.ncpu) && \
mkdir -p llama-swap/build && \
go build -C llama-swap -o build/llama-swap . && \
npm --prefix llama-swap/ui install && \
npm --prefix llama-swap/ui run build
```

---

## 4. Download Models

Create the models directory and download `.gguf` files:

```sh
mkdir -p models
```

### Recommended Models

| Model | Size | Use Case |
|-------|------|----------|
| Llama-3.2-3B-Instruct-Q8_0.gguf | ~3GB | Fast responses |
| Qwen2.5-7B-Instruct-Q5_K_M.gguf | ~5GB | General purpose |
| Qwen2.5-Coder-14B-Instruct-Q4_K_M.gguf | ~8GB | Coding |

Download from [Hugging Face](https://huggingface.co/models?sort=trending&search=gguf).

Ensure filenames match those in `config.yaml`, or update the config.

---

## 5. Run

```sh
./llama-swap/build/llama-swap --config config.yaml --listen :8080
```

### Access Points
| URL | Description |
|-----|-------------|
| http://localhost:8080/ui/ | llama-swap dashboard |
| http://localhost:8080/upstream/{model}/ | llama.cpp chat UI for a model |
| http://localhost:8080/v1/chat/completions | OpenAI-compatible API |

---

## 6. Update Submodules

Pull latest versions of llama.cpp and llama-swap:

```sh
git submodule update --remote
```

Then rebuild (repeat step 3).

> ⚠️ If you've made local changes to submodules, you may get merge conflicts.

---

## Troubleshooting

### `tsc: command not found`
Run `npm install` in the `llama-swap/ui` directory first.

### Model fails to load
- Check the model path in `config.yaml`
- Ensure the `.gguf` file exists in `models/`
- Check available VRAM for `--n-gpu-layers`

### Port already in use
```sh
lsof -i :8080  # Find process using port
kill -9 <PID>  # Kill it
```
