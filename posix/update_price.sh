#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <distributor_id> <file_path> [inc]" >&2
  exit 2
fi

: "${API_USERNAME:?API_USERNAME must be set}"
: "${API_USERPSW:?API_USERPSW must be set}"
: "${API_HOST:?API_HOST must be set}"

DISTRIBUTOR_ID="$1"
FILE_PATH="$2"
MODE="${3:-full}"

if [[ ! -f "$FILE_PATH" ]]; then
  echo "Error: file not found: $FILE_PATH" >&2
  exit 2
fi

FILE_TYPE_ID="1"
if [[ "$MODE" == "inc" ]]; then
  FILE_TYPE_ID="4"
fi

if [[ "$API_HOST" == http://* || "$API_HOST" == https://* ]]; then
  BASE_URL="${API_HOST%/}"
else
  BASE_URL="https://${API_HOST%/}"
fi

echo "Uploading price list..."

curl --fail --show-error --silent \
  -X POST \
  -H "Content-Type: multipart/form-data" \
  -F "userlogin=${API_USERNAME}" \
  -F "userpsw=${API_USERPSW}" \
  -F "distributorId=${DISTRIBUTOR_ID}" \
  -F "fileTypeId=${FILE_TYPE_ID}" \
  -F "uploadFile=@${FILE_PATH}" \
  "${BASE_URL}/cp/distributor/pricelistUpdate"
echo
