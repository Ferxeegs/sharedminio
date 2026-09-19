#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT_DIR}"

if [[ ! -f .env ]]; then
  echo "Missing .env — copy from .env.example first."
  exit 1
fi

# shellcheck disable=SC1091
set -a
# shellcheck source=/dev/null
source .env
set +a

ENDPOINT="${SMOKE_ENDPOINT:-http://127.0.0.1:${MINIO_API_PORT:-9000}}"
BUCKET="purchasing-go-documents"
OBJECT_KEY="temporary/smoke-test.txt"
TMP_FILE="$(mktemp)"
echo "sharedminio smoke $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "${TMP_FILE}"

cleanup() {
  rm -f "${TMP_FILE}"
}
trap cleanup EXIT

echo "1) MinIO live health"
curl -fsS "${ENDPOINT}/minio/health/live" >/dev/null
echo "   ok"

echo "2) Upload / HEAD / delete with purchasing-go credentials"
docker run --rm --network app-bridge \
  --entrypoint /bin/sh \
  -v "${TMP_FILE}:/tmp/smoke.txt:ro" \
  quay.io/minio/mc:RELEASE.2025-04-16T18-13-26Z \
  -c "
    mc alias set local http://minio:9000 '${PURCHASING_GO_ACCESS_KEY}' '${PURCHASING_GO_SECRET_KEY}' &&
    mc cp /tmp/smoke.txt 'local/${BUCKET}/${OBJECT_KEY}' &&
    mc stat 'local/${BUCKET}/${OBJECT_KEY}' &&
    mc rm 'local/${BUCKET}/${OBJECT_KEY}'
  "

echo "3) Upload / HEAD / delete with siperbook credentials"
SIPERBOOK_BUCKET="siperbook-documents"
docker run --rm --network app-bridge \
  --entrypoint /bin/sh \
  -v "${TMP_FILE}:/tmp/smoke.txt:ro" \
  quay.io/minio/mc:RELEASE.2025-04-16T18-13-26Z \
  -c "
    mc alias set local http://minio:9000 '${SIPERBOOK_ACCESS_KEY}' '${SIPERBOOK_SECRET_KEY}' &&
    mc cp /tmp/smoke.txt 'local/${SIPERBOOK_BUCKET}/${OBJECT_KEY}' &&
    mc stat 'local/${SIPERBOOK_BUCKET}/${OBJECT_KEY}' &&
    mc rm 'local/${SIPERBOOK_BUCKET}/${OBJECT_KEY}'
  "

echo "Smoke test passed."
