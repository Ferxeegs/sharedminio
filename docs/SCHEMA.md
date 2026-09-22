# Storage Schema — Shared MinIO

## 1. Bucket

### purchasing-go

```text
purchasing-go-documents          # privat
purchasing-go-public-documents   # publik (anonymous download)
```

### siperbook

```text
siperbook-documents              # privat
siperbook-public-documents       # publik (anonymous download)
```

### dpupk-skp

```text
skp-documents                    # privat
skp-public-documents             # publik (anonymous download)
```

## 2. Struktur Object Key

Pola umum:

```text
{entity_type}/{year}/{month}/{entity_id}/{file_uuid}.{extension}
```

Contoh purchasing-go:

```text
invoices/2026/09/{po_id}/{uuid}.pdf
attachments/2026/09/{rfq_id}/{uuid}.jpg
```

Contoh siperbook (sesuai kode aplikasi):

```text
{model_type}/{collection}/{stored_filename}
```

Nama file asli sebaiknya tidak dipakai mentah sebagai object key; gunakan UUID jika memungkinkan.

## 3. Visibility

| Bucket | Arti |
|---|---|
| `*-documents` | Privat — hanya kredensial app / presigned URL |
| `*-public-documents` | Publik — anonymous download seluruh bucket |

## 4. Penyimpanan URL

Database aplikasi menyimpan `bucket_name` + `object_key`, bukan presigned URL.
