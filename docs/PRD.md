# Product Requirements Document — Shared MinIO (purchasing-go)

## 1. Ringkasan

**Nama sistem:** Shared MinIO  
**Konsumen:** purchasing-go  
**Status:** Aktif  

Shared MinIO adalah layanan object storage berbasis MinIO dan Docker Compose untuk menyimpan file aplikasi purchasing-go.

## 2. Tujuan

1. Menyediakan object storage S3-compatible terpusat.
2. Memisahkan penyimpanan file dari filesystem aplikasi.
3. Mendukung file privat dan publik.
4. Menyediakan monitoring kapasitas dan availability (Prometheus/Grafana).

## 3. Ruang Lingkup

### Termasuk

- MinIO single node pada Docker Compose.
- Akses langsung ke S3 API (tanpa Nginx).
- Bucket `purchasing-go-documents` (privat) dan `purchasing-go-public-documents` (publik).
- Access key aplikasi purchasing-go.
- Monitoring Prometheus + Grafana.

### Tidak termasuk

- High availability / distributed MinIO.
- Reverse proxy Nginx di stack ini.
- Backup eksternal (belum ada media tujuan).

## 4. Acceptance

1. Stack Compose sehat.
2. Bucket dan user purchasing-go terbuat otomatis oleh `minio-init`.
3. purchasing-go dapat upload/download dengan kredensial aplikasinya.
4. Smoke test lulus.
