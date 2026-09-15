#!/usr/bin/env bash
set -Eeuo pipefail

REPO="https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main"
VERSION="5.4.0"
EXPECTED_SHA256="d99f011d3bdebddc1329be61d2482e5b32b205f72364d1fe729bb82f552d2ad5"

for cmd in curl base64 sha256sum tar; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Error: $cmd is required." >&2
    exit 1
  }
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Personal AI Activity Collector v$VERSION"
echo "Downloading verified release from GitHub..."

: > "$TMP/payload.b64"
for i in $(seq -w 0 14); do
  curl -fsSL "$REPO/payload/v$VERSION/part-$i.b64" >> "$TMP/payload.b64"
done

base64 -d "$TMP/payload.b64" > "$TMP/personal-ai-$VERSION.tar.xz"

ACTUAL="$(sha256sum "$TMP/personal-ai-$VERSION.tar.xz" | awk '{print $1}')"
if [[ "$ACTUAL" != "$EXPECTED_SHA256" ]]; then
  echo "Error: checksum verification failed." >&2
  echo "Expected: $EXPECTED_SHA256" >&2
  echo "Actual:   $ACTUAL" >&2
  exit 1
fi

echo "Checksum verified."
mkdir -p "$TMP/extract"
tar -xJf "$TMP/personal-ai-$VERSION.tar.xz" -C "$TMP/extract"

INSTALLER="$TMP/extract/personal-ai-activity-collector/packaging/install.sh"
if [[ ! -f "$INSTALLER" ]]; then
  echo "Error: installer was not found in the verified package." >&2
  exit 1
fi
chmod +x "$INSTALLER"
exec "$INSTALLER"
