# Deployment — Shared MinIO (purchasing-go)

## Prasyarat

- Ubuntu 24.04 LTS (atau setara).
- Akses sudo.
- Docker Engine dan Docker Compose plugin.
- Firewall yang membatasi akses port MinIO ke host aplikasi yang dipercaya.

## Struktur

```text
# Repository / deploy path (contoh: /opt/sharedminio)
.
├── docker-compose.yml
├── .env
├── prometheus/
├── grafana/
├── policies/
└── scripts/

# Persistent object data (di luar repo)
/srv/sharedminio/
└── data/
```

Atur path data melalui `MINIO_DATA_PATH` di `.env`:

- lokal: `./data`
- production: `/srv/sharedminio/data`

## Urutan Deployment

1. Audit kapasitas disk.
2. Instal Docker Engine dan Compose.
3. Pastikan Docker network `app-bridge` ada (`docker network create app-bridge` bila belum).
4. Buat direktori data persisten (`/srv/sharedminio/data`).
5. Clone repo ke `/opt/sharedminio`, salin `.env.example` → `.env`.
6. Jalankan stack: `docker compose up -d`.
7. Init job (`minio-init`) membuat bucket, user, dan policy purchasing-go.
8. Verifikasi Prometheus dan Grafana.
9. Uji health dan upload (`./scripts/smoke-test.sh`).
10. Integrasikan purchasing-go lewat network `app-bridge` (hostname `minio:9000`) atau via host port.

## Perintah

```bash
cd /opt/sharedminio
docker network create app-bridge   # skip jika sudah ada
cp .env.example .env
# edit secret
mkdir -p /srv/sharedminio/data
# set MINIO_DATA_PATH=/srv/sharedminio/data pada production
docker compose up -d
docker compose logs -f minio-init
./scripts/smoke-test.sh
```

## Guardrail

- Jangan menjalankan `docker compose down -v` pada production.
- Jangan menghapus `/srv/sharedminio/data` saat update container.
- Jangan menggunakan root credential pada aplikasi purchasing-go.
- Batasi port `9000`/`9001` lewat firewall (bukan internet publik).
- Tidak ada Nginx; aplikasi memakai S3 API MinIO langsung.
