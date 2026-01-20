# Monitoramento e APM — Configuração do projeto

Resumo rápido:
- Rede Docker externa: `observability` (crie com `docker network create observability` se necessário).
- Serviços principais (via `docker-compose.yaml`): `elasticsearch` (9200), `kibana` (5601), `apm` (8200), `metricbeat`, `heartbeat`, `prometheus`, `grafana`, `cadvisor`, `redis`, `prometheus-app` (Go) e `app` (Django).

**Elasticsearch**
- Acesso: `http://localhost:9200`
- Dados persistem em `./elasticsearch_data` por padrão (veja `docker-compose.yaml`).

**Kibana**
- Acesso: `http://localhost:5601`
- Usado para visualizar APM, Beats e dashboards.

**APM Server**
- Arquivo: `apm/apm-server.yml`.
- Acesso: `http://localhost:8200`.
- RUM: `rum.enabled: true`, `rum.allow_origins: ['*']` (recomenda-se restringir em produção).

**Metricbeat**
- Arquivo: `beats/metric/metricbeat.yml` (cópia embutida na imagem construída).
- Monitora Docker e Elasticsearch; exporta para `elasticsearch:9200`.

**Heartbeat**
- Arquivo: `beats/heartbeat/heartbeat.yml`.
- Monitora endpoints HTTP/ICMP (agora inclui `prometheus-app`).

**Prometheus**
- Serviço: `prometheus` (veja `prometheus-app/docker-compose.yaml`).
- Acesso: `http://localhost:9090`.
- Config: `prometheus-app/prometheus.yml` (scrape de `prometheus`, `cadvisor`, `app`).

**Grafana**
- Serviço: `grafana` (veja `prometheus-app/docker-compose.yaml`).
- Acesso: `http://localhost:3000`.
- Observação: Grafana faz provisioning ao iniciar; dados persistem no container a menos que você adicione volume.
usuário e senha padrão: admin admin

**cAdvisor**
- Serviço: `cadvisor` expõe `8080` para métricas de containers (usado pelo Prometheus).

**Redis**
- Serviço: `redis` exposto em `6379`.

**prometheus-app (Go)**
- Código: `prometheus-app/main.go` — servidor Go que expõe `/` e `/metrics` em `:8181`.
- No compose: mapeado `8181:8181`. Acesse `http://localhost:8181` e `http://localhost:8181/metrics`.

**app (Django)**
- Serviço: `app` (Django) definido em `app/docker-compose.yaml` e em `app/`.
- Acesso de desenvolvimento: `http://localhost:8000` (ou via `nginx` em `http://localhost:8280` se estiver usando nginx do compose).

Observações sobre Windows/WSL2 e permissões
- Bind-mount direto dos arquivos `.yml` em Windows causa problemas de permissão dentro dos containers (arquivos aparecem como `-rwxrwxrwx` e o Beat/APM recusa configs world-writable).
- Solução adotada: imagens customizadas (build) para `apm`, `metricbeat` e `heartbeat` que copiam os arquivos `.yml` para a imagem e ajustam permissões (`chmod 644`) durante o build. Ver: `apm/Dockerfile`, `beats/metric/Dockerfile`, `beats/heartbeat/Dockerfile`.

Como subir o projeto (passos)
1. Criar a rede Docker (uma vez):

```powershell
docker network create observability
```

2. Subir os serviços (do diretório raiz do repo):

```powershell
docker compose up -d --build
```

3. Subir apenas o stack Prometheus/Grafana (se desejar isolar):

```powershell
cd prometheus-app
docker compose up -d --build
```

4. Verificar status:

```powershell
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
docker logs apm --tail 200
```

Acessos úteis
- Elasticsearch: http://localhost:9200
- Kibana: http://localhost:5601
- APM Server: http://localhost:8200
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000
- Go app metrics: http://localhost:8181/metrics
- Django app: http://localhost:8000 (ou http://localhost:8280 via nginx)

Notas finais
- Em ambiente de produção, configure `apm-server.secret_token`, TLS (`ssl`) e restrinja `rum.allow_origins`.
- Para adaptar a configuração (ex.: uso de credenciais diferentes ou endpoints remotos), edite os arquivos em `apm/`, `beats/` e `prometheus-app/` e rode `docker compose up -d --build`.

