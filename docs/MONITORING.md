# Monitoring — Shared MinIO (purchasing-go)

## Stack

- MinIO metrics.
- Prometheus.
- Grafana.
- Alertmanager atau kanal alert yang ditentukan kemudian.

## Metrik Utama

- availability MinIO;
- disk usage dan free space;
- jumlah object;
- request rate;
- error rate;
- latency;
- container restart;
- CPU dan RAM host;
- status backup setelah backup tersedia.

## Alert Awal

| Alert | Kondisi |
|---|---|
| MinIODown | gagal diakses lebih dari 2 menit |
| DiskWarning | penggunaan disk >= 70% |
| DiskAction | penggunaan disk >= 80% |
| DiskCritical | penggunaan disk >= 90% |
| DiskEmergency | penggunaan disk >= 95% |
| HighErrorRate | rasio error melewati baseline |
| ContainerRestartLoop | restart berulang |

## Retention

Prometheus retention awal 15–30 hari dan harus disesuaikan dengan kapasitas disk aktual.
