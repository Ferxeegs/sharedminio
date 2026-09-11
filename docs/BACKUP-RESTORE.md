# Backup and Restore — Shared MinIO (purchasing-go)

## Status Saat Ini

Belum tersedia NAS, server kedua, atau cloud storage. Karena itu, disaster-recovery backup belum tersedia.

## Prinsip

- Salinan pada disk fisik yang sama bukan backup bencana.
- Backup harus berada di media atau lokasi berbeda.
- Restore harus diuji, bukan hanya backup dibuat.

## Target Masa Depan

- RPO target: 24 jam.
- RTO target: 4 jam.
- Backup harian.
- Retention harian 14 hari, mingguan 8 minggu, bulanan 12 bulan.
- Restore test minimal per kuartal.

## Catatan

Sebelum tujuan eksternal tersedia, RPO dan RTO tidak dapat dijamin dan harus dicatat sebagai risiko production. Data object berada di `MINIO_DATA_PATH` (production: `/srv/sharedminio/data`).
