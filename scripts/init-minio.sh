#!/bin/sh
set -eu

ENDPOINT="${MINIO_ENDPOINT:-http://minio:9000}"
ALIAS="local"
PURCHASING_PRIVATE_BUCKET="purchasing-go-documents"
PURCHASING_PUBLIC_BUCKET="purchasing-go-public-documents"
SIPERBOOK_PRIVATE_BUCKET="siperbook-documents"
SIPERBOOK_PUBLIC_BUCKET="siperbook-public-documents"

echo "Waiting for MinIO at ${ENDPOINT} ..."
i=0
until mc alias set "${ALIAS}" "${ENDPOINT}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "${i}" -ge 60 ]; then
    echo "MinIO did not become ready in time."
    exit 1
  fi
  sleep 2
done

ensure_policy() {
  policy_name="$1"
  policy_file="$2"
  if mc admin policy info "${ALIAS}" "${policy_name}" >/dev/null 2>&1; then
    mc admin policy remove "${ALIAS}" "${policy_name}" >/dev/null 2>&1 || true
  fi
  mc admin policy create "${ALIAS}" "${policy_name}" "${policy_file}"
}

create_app_user() {
  access_key="$1"
  secret_key="$2"
  policy_name="$3"
  policy_file="$4"

  if mc admin user info "${ALIAS}" "${access_key}" >/dev/null 2>&1; then
    mc admin user remove "${ALIAS}" "${access_key}"
  fi

  ensure_policy "${policy_name}" "${policy_file}"
  mc admin user add "${ALIAS}" "${access_key}" "${secret_key}"
  mc admin policy attach "${ALIAS}" "${policy_name}" --user "${access_key}"
}

echo "MinIO is ready. Creating purchasing-go buckets ..."
mc mb --ignore-existing "${ALIAS}/${PURCHASING_PRIVATE_BUCKET}"
mc mb --ignore-existing "${ALIAS}/${PURCHASING_PUBLIC_BUCKET}"

echo "Applying anonymous public-read on ${PURCHASING_PUBLIC_BUCKET} ..."
mc anonymous set download "${ALIAS}/${PURCHASING_PUBLIC_BUCKET}" || true

echo "Creating purchasing-go application user ..."
create_app_user \
  "${PURCHASING_GO_ACCESS_KEY}" \
  "${PURCHASING_GO_SECRET_KEY}" \
  "purchasing-go-rw" \
  "/policies/purchasing-go-rw.json"

echo "Creating siperbook buckets ..."
mc mb --ignore-existing "${ALIAS}/${SIPERBOOK_PRIVATE_BUCKET}"
mc mb --ignore-existing "${ALIAS}/${SIPERBOOK_PUBLIC_BUCKET}"

echo "Applying anonymous public-read on ${SIPERBOOK_PUBLIC_BUCKET} ..."
mc anonymous set download "${ALIAS}/${SIPERBOOK_PUBLIC_BUCKET}" || true

echo "Creating siperbook application user ..."
create_app_user \
  "${SIPERBOOK_ACCESS_KEY}" \
  "${SIPERBOOK_SECRET_KEY}" \
  "siperbook-rw" \
  "/policies/siperbook-rw.json"

echo "Init complete."
mc ls "${ALIAS}"
