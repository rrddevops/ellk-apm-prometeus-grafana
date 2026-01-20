# Inicio: scripts/start_services.ps1
# Uso: execute a partir da raiz do repositório

$ErrorActionPreference = 'Stop'

Write-Output "[start_services] Verificando rede 'observability'..."
$networks = docker network ls --format "{{.Name}}"
if (-not ($networks -match 'observability')) {
    Write-Output "[start_services] Rede 'observability' não existe. Criando..."
    docker network create observability | Out-Null
} else {
    Write-Output "[start_services] Rede 'observability' já existe."
}

Write-Output "[start_services] Subindo serviços do compose da pasta 'app' (db, app, nginx, etc.)..."
Push-Location -Path (Join-Path $PSScriptRoot "..")
try {
    docker compose -f .\app\docker-compose.yaml up -d --build app
} finally {
    Pop-Location
}

Write-Output "[start_services] Subindo 'prometheus-app' (do compose raiz)..."
docker compose up -d --build prometheus-app

Write-Output "[start_services] Status dos containers relevantes:"
docker ps --filter "name=app" --filter "name=prometheus-app" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

Write-Output "[start_services] Concluído. Use 'docker logs <container>' para ver logs."