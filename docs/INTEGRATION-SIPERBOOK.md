# Integrasi siperbook ↔ Shared MinIO

## Endpoint & kredensial

| Item | Nilai |
|---|---|
| Endpoint (Docker `app-bridge`) | `http://minio:9000` |
| Endpoint (host) | `http://127.0.0.1:9000` |
| Region | `us-east-1` (dummy, wajib diisi SDK) |
| Path-style | `true` (wajib untuk MinIO) |
| Access key | `SIPERBOOK_ACCESS_KEY` |
| Secret key | `SIPERBOOK_SECRET_KEY` |
| Bucket privat | `siperbook-documents` |
| Bucket publik | `siperbook-public-documents` |

Jangan memakai root MinIO di aplikasi.

## Variabel env di siperbook

```env
S3_ENABLED=true
S3_ENDPOINT_URL=http://minio:9000
S3_ACCESS_KEY_ID=<SIPERBOOK_ACCESS_KEY>
S3_SECRET_ACCESS_KEY=<SIPERBOOK_SECRET_KEY>
S3_BUCKET=siperbook-documents
S3_PUBLIC_BUCKET=siperbook-public-documents
S3_REGION=us-east-1
S3_ADDRESSING_STYLE=path
S3_USE_SSL=false
# Browser-reachable base (local):
S3_PUBLIC_BROWSER_BASE_URL=http://localhost:9000
# Production via reverse proxy (contoh):
# S3_PUBLIC_BROWSER_BASE_URL=https://siperbook.ferxcode.my.id/minio
```

Semua file aplikasi disimpan di bucket privat `siperbook-documents`:

| Fitur | Object key |
|---|---|
| Media upload | `{model_type}/{collection}/{uuid}{ext}` |
| Keyword scan | `keyword_scans/{scan_id}/original.docx` (+ `edited.docx` / `highlighted.docx`) |

Pastikan container siperbook join network `app-bridge` (sama dengan stack sharedminio).

## URL publik

Object di `siperbook-public-documents` bisa diakses langsung:

```text
http://minio:9000/siperbook-public-documents/{object_key}
```

Untuk browser di host: `http://127.0.0.1:9000/...` atau via reverse proxy `/minio/...`.

## Catatan

- Simpan `bucket` + `object_key` di database, bukan URL temporary.
- Jalankan `docker compose up -d` di repo `sharedminio` sebelum stack siperbook.
- Init bucket/user: container `sharedminio-minio-init` (idempotent pada setiap recreate).
