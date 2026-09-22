# Integrasi dpupk-skp ↔ Shared MinIO

## Endpoint & kredensial

| Item | Nilai |
|---|---|
| Endpoint (Docker `app-bridge`) | `http://minio:9000` |
| Endpoint (host) | `http://127.0.0.1:9000` |
| Region | `us-east-1` (dummy, wajib diisi SDK) |
| Path-style | `true` (wajib untuk MinIO) |
| Access key | `SKP_ACCESS_KEY` |
| Secret key | `SKP_SECRET_KEY` |
| Bucket privat | `skp-documents` |
| Bucket publik | `skp-public-documents` |

Jangan memakai root MinIO di aplikasi.

## Variabel env di dpupk-skp

```env
S3_ENDPOINT_URL=http://minio:9000
S3_PUBLIC_ENDPOINT_URL=/storage
S3_ACCESS_KEY=<SKP_ACCESS_KEY>
S3_SECRET_KEY=<SKP_SECRET_KEY>
S3_BUCKET=skp-documents
S3_PUBLIC_BUCKET=skp-public-documents
S3_REGION=us-east-1
S3_USE_SSL=false
S3_FORCE_PATH_STYLE=true
```

Pastikan container dpupk-skp join network `app-bridge` (sama dengan stack sharedminio).

## URL publik

Object di `skp-public-documents` diproxy nginx aplikasi via `/storage/`:

```text
http://localhost/storage/{object_key}
```

Akses langsung MinIO (debug): `http://127.0.0.1:9000/skp-public-documents/{object_key}`.

## Catatan

- Simpan `bucket` + `object_key` di database, bukan URL temporary.
- Jalankan `docker compose up -d` di repo `sharedminio` sebelum stack dpupk-skp.
- Init bucket/user: container `sharedminio-minio-init` (idempotent pada setiap recreate).
