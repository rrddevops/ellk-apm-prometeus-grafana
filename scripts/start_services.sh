#!/usr/bin/env bash
set -euo pipefail

echo "[start_services] Verificando rede 'observability'..."
if ! docker network ls --format '{{.Name}}' | grep -q '^observability$'; then
  echo "[start_services] Rede 'observability' não existe. Criando..."
  docker network create observability >/dev/null
else
  echo "[start_services] Rede 'observability' já existe."
fi

echo "[start_services] Subindo serviços do compose da pasta 'app' (db, app, nginx, etc.)..."
( cd "$(dirname "$0")/.." && docker compose -f ./app/docker-compose.yaml up -d --build app )

echo "[start_services] Subindo 'prometheus-app' (do compose raiz)..."
docker compose up -d --build prometheus-app

echo "[start_services] Status dos containers relevantes:"
docker ps --filter "name=app" --filter "name=prometheus-app" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo "[start_services] Concluído. Use 'docker logs <container>' para ver logs."