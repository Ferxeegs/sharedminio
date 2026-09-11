# Security — Shared MinIO (purchasing-go)

## Prinsip

- Least privilege.
- Deny by default.
- Secret tidak berada di frontend atau Git.
- Console hanya melalui VPN/jaringan internal.
- Prefer TLS di jaringan produksi bila tersedia (gateway/VPN); stack ini mengekspos MinIO langsung tanpa Nginx.

## Kredensial

- Root credential hanya untuk administrator.
- Buat user aplikasi purchasing-go terpisah dari root.
- Rotasi access key secara berkala dan segera jika dicurigai bocor.
- Simpan secret di `.env` dengan permission ketat atau secret manager.

## Hak Akses

User purchasing-go hanya boleh:

- melihat bucket `purchasing-go-documents` dan `purchasing-go-public-documents`;
- `GetObject`, `PutObject`, `DeleteObject`, dan `HeadObject` pada kedua bucket tersebut;
- tidak membuat atau menghapus bucket;
- tidak mengakses bucket aplikasi lain.

## Public Access

Hanya bucket `purchasing-go-public-documents` yang boleh anonymous download. File di `purchasing-go-documents` wajib melalui kredensial app atau presigned URL.

## Network

- Aplikasi mengakses S3 API MinIO langsung di port `MINIO_API_PORT` (default 9000).
- Port MinIO tidak dibuka ke internet publik.
- Console (`MINIO_CONSOLE_PORT`) dibatasi VPN/internal.
- Firewall host hanya membuka port yang diperlukan ke host aplikasi yang dipercaya.

## Incident Credential Leak

1. Nonaktifkan access key terkait.
2. Buat access key baru.
3. Perbarui secret aplikasi.
4. Restart/reload aplikasi.
5. Tinjau audit log dan object yang berubah.
6. Dokumentasikan insiden.
