FROM python:3.11-slim

# Evita prompts durante instalações
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências básicas e Robot Framework com RequestsLibrary
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && pip install --no-cache-dir \
        robotframework \
        robotframework-requests \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define diretório padrão
WORKDIR /tests

# Comando padrão (sobrescrito no entrypoint da pipeline)
ENTRYPOINT ["robot"]

