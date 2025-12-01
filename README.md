# Prereq
Go 

# Build
```sh
cd /Users/reinder/Documents/GitHub/LLLM/llama.cpp && cmake -B build && cmake --build build --config Release -j 14
```

```sh
cd /Users/reinder/Documents/GitHub/LLLM/llama-swap && make clean all 2>&1
go build -o build/llama-swap .
```


# Run
```sh
cd /Users/reinder/Documents/GitHub/LLLM && ./llama-swap/build/llama-swap --config config.yaml --listen :8080
```
