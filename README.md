# Shared MinIO

Shared object storage berbasis MinIO untuk aplikasi **purchasing-go** dan **siperbook**. Stack: Docker Compose, Prometheus, dan Grafana. Aplikasi mengakses S3 API MinIO secara langsung (tanpa Nginx).

## Struktur

```text
.
├── docker-compose.yml
├── .env.example
├── prometheus/
├── grafana/
├── policies/
├── scripts/
└── docs/
```

Di server production, clone repo ke `/opt/sharedminio` (atau path setara). Data object tetap di `/srv/sharedminio/data` melalui `MINIO_DATA_PATH`.

## Quick start (lokal)

```bash
# buat network bersama jika belum ada (sama dengan project aplikasi)
docker network create app-bridge

cp .env.example .env
# edit password di .env
docker compose up -d
./scripts/smoke-test.sh
```

- S3 API: `http://127.0.0.1:9000`
- MinIO Console: `http://127.0.0.1:9001` — login pakai `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD`
- Grafana: `http://127.0.0.1:3030` (atur `GRAFANA_PORT` di `.env`)

## Bucket & kredensial

### purchasing-go

| Bucket | Akses |
|---|---|
| `purchasing-go-documents` | Privat (kredensial / presigned URL) |
| `purchasing-go-public-documents` | Publik (anonymous download) |

Kredensial app: `PURCHASING_GO_ACCESS_KEY` / `PURCHASING_GO_SECRET_KEY`

### siperbook

| Bucket | Akses |
|---|---|
| `siperbook-documents` | Privat (kredensial / presigned URL) |
| `siperbook-public-documents` | Publik (anonymous download) |

Kredensial app: `SIPERBOOK_ACCESS_KEY` / `SIPERBOOK_SECRET_KEY`

Dari container di network `app-bridge`: `http://minio:9000`

## Dokumen

- `docs/PRD.md`
- `docs/ARCHITECTURE.md`
- `docs/SCHEMA.md`
- `docs/SECURITY.md`
- `docs/DEPLOYMENT.md`
- `docs/INTEGRATION-GO.md`
- `docs/INTEGRATION-SIPERBOOK.md`
- `docs/MONITORING.md`
- `docs/BACKUP-RESTORE.md`
- `docs/RUNBOOK.md`
