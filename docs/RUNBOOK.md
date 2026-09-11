# Operational Runbook — Shared MinIO (purchasing-go)

## MinIO Tidak Dapat Diakses

1. Periksa jaringan/firewall ke host MinIO.
2. Periksa `docker compose ps` di root deploy (`/opt/sharedminio` atau path setara).
3. Periksa log MinIO (`docker compose logs minio`).
4. Periksa kapasitas disk dan inode (`MINIO_DATA_PATH`, default production `/srv/sharedminio/data`).
5. Restart hanya service yang diperlukan (`docker compose restart minio`).
6. Catat waktu dan penyebab insiden.

## Disk Hampir Penuh

1. Hentikan pertumbuhan log yang tidak terkendali.
2. Identifikasi konsumsi Docker, Prometheus, aplikasi, dan MinIO.
3. Jangan menghapus object production secara manual tanpa verifikasi.
4. Tambah kapasitas atau pindahkan data.
5. Validasi service setelah tindakan.

## Access Key Bocor

1. Revoke key.
2. Buat key baru.
3. Perbarui secret aplikasi purchasing-go.
4. Audit log.
5. Tinjau object yang dibuat, diubah, atau dihapus.

## Upload Gagal

1. Periksa masa berlaku presigned URL.
2. Periksa ukuran file, MIME, CORS (jika browser), dan konektivitas ke `:9000`.
3. Periksa policy user purchasing-go.
4. Periksa record status upload di aplikasi.

## File Tidak Ditemukan

1. Verifikasi bucket dan object key di database.
2. Jalankan HEAD object.
3. Periksa apakah pengguna sebelumnya menghapus file.
4. Periksa log aplikasi.
5. Karena backup belum tersedia, eskalasi sebagai potensi kehilangan data.
