# !bin/bash

# 1. Start Ollama service
# ollama serve

# 2. Open a new terminal

# 3. Set context window size and save the monitor
# ollama run gpt-oss:20b
# /set parameter num_ctx 10000
# /save gpt-oss:20b
# ctrl^c

function copilot {
    OLLAMA_ORIGINS=app://obsidian.md* ollama serve
}