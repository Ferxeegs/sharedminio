# Architecture — Shared MinIO

## 1. Ringkasan

Shared MinIO adalah object storage S3-compatible single-node berbasis Docker Compose. Aplikasi **purchasing-go** dan **siperbook** mengakses API MinIO secara langsung. Prometheus dan Grafana menyediakan observability. Tidak ada Nginx di stack ini.

## 2. Context Diagram

```mermaid
flowchart LR
    U[Pengguna] --> APP1[purchasing-go]
    U --> APP2[siperbook]
    APP1 --> DB1[(Database)]
    APP2 --> DB2[(Database)]
    APP1 -->|S3 API| MI[MinIO :9000]
    APP2 -->|S3 API| MI
    MI --> DATA[/Persistent Storage/]
    MI --> PROM[Prometheus]
    PROM --> GRAF[Grafana]
    GRAF --> ADMIN[Administrator]
```

## 3. Port & Network

Semua service berada di Docker network eksternal `app-bridge` (sama dengan project aplikasi). Dari container lain di network itu, S3 API diakses sebagai `http://minio:9000`.

| Port host | Service | Catatan |
|---|---|---|
| `MINIO_API_PORT` (default 9000) | S3 API | Dipakai purchasing-go & siperbook |
| `MINIO_CONSOLE_PORT` (default 9001) | Console | Admin / VPN only |
| `GRAFANA_PORT` (default 3030) | Grafana | Monitoring UI |

Port MinIO tidak boleh diekspos ke internet publik tanpa kontrol akses.

## 4. Path

```text
/opt/sharedminio/          deploy path repo
/srv/sharedminio/data/     object MinIO (MINIO_DATA_PATH)
```

## 5. Bucket & kredensial

| App | Bucket privat | Bucket publik | Kredensial |
|---|---|---|---|
| purchasing-go | `purchasing-go-documents` | `purchasing-go-public-documents` | `PURCHASING_GO_*` |
| siperbook | `siperbook-documents` | `siperbook-public-documents` | `SIPERBOOK_*` |

## 6. Retention Monitoring

Prometheus retention dibatasi (default 15 hari) agar monitoring tidak menghabiskan disk.
