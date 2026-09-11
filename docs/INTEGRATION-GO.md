# Integrasi purchasing-go ↔ Shared MinIO

## Endpoint & kredensial

| Item | Nilai |
|---|---|
| Endpoint (Docker `app-bridge`) | `http://minio:9000` |
| Endpoint (host) | `http://127.0.0.1:9000` |
| Region | `us-east-1` (dummy, wajib diisi SDK) |
| Path-style | `true` (wajib untuk MinIO) |
| Access key | `PURCHASING_GO_ACCESS_KEY` |
| Secret key | `PURCHASING_GO_SECRET_KEY` |
| Bucket privat | `purchasing-go-documents` |
| Bucket publik | `purchasing-go-public-documents` |

Jangan memakai root MinIO di aplikasi.

## Contoh client Go (AWS SDK v2)

```go
cfg, err := config.LoadDefaultConfig(ctx,
    config.WithRegion("us-east-1"),
    config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(
        os.Getenv("PURCHASING_GO_ACCESS_KEY"),
        os.Getenv("PURCHASING_GO_SECRET_KEY"),
        "",
    )),
)
if err != nil {
    return err
}

client := s3.NewFromConfig(cfg, func(o *s3.Options) {
    o.BaseEndpoint = aws.String(os.Getenv("MINIO_ENDPOINT")) // http://minio:9000
    o.UsePathStyle = true
})
```

## Upload

```go
_, err = client.PutObject(ctx, &s3.PutObjectInput{
    Bucket:      aws.String("purchasing-go-documents"),
    Key:         aws.String(objectKey),
    Body:        file,
    ContentType: aws.String(contentType),
})
```

## URL publik

Object di `purchasing-go-public-documents` bisa diakses langsung:

```text
http://minio:9000/purchasing-go-public-documents/{object_key}
```

Untuk browser di host, ganti `minio` dengan `127.0.0.1` atau hostname server.

## URL privat (presigned)

```go
presignClient := s3.NewPresignClient(client)
out, err := presignClient.PresignGetObject(ctx, &s3.GetObjectInput{
    Bucket: aws.String("purchasing-go-documents"),
    Key:    aws.String(objectKey),
}, s3.WithPresignExpires(10*time.Minute))
// out.URL
```

## Catatan

- Simpan `bucket` + `object_key` di database, bukan URL temporary.
- Pastikan service purchasing-go join network `app-bridge`.
