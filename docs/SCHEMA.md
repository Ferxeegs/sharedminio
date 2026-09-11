# Storage Schema — Shared MinIO (purchasing-go)

## 1. Bucket

purchasing-go memakai dua bucket:

```text
purchasing-go-documents          # privat
purchasing-go-public-documents   # publik (anonymous download)
```

## 2. Struktur Object Key

Pola umum:

```text
{entity_type}/{year}/{month}/{entity_id}/{file_uuid}.{extension}
```

Contoh:

```text
invoices/2026/09/{po_id}/{uuid}.pdf
attachments/2026/09/{rfq_id}/{uuid}.jpg
```

Nama file asli tidak dipakai sebagai object key; gunakan UUID.

## 3. Visibility

| Bucket | Arti |
|---|---|
| `purchasing-go-documents` | Privat — hanya kredensial app / presigned URL |
| `purchasing-go-public-documents` | Publik — anonymous download seluruh bucket |

## 4. Penyimpanan URL

Database aplikasi menyimpan `bucket_name` + `object_key`, bukan presigned URL.
