#!/usr/bin/env bash
set -Eeuo pipefail

REPO="https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main"
VERSION="5.5.0"
BASE_VERSION="5.4.0"
BASE_SHA256="d99f011d3bdebddc1329be61d2482e5b32b205f72364d1fe729bb82f552d2ad5"
OVERLAY_SHA256="ed273fbd1ca7c8f83d075d9be6458c109a9e21080dac3f5bf52aadca4ef15a71"

for cmd in curl base64 sha256sum tar; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Error: $cmd is required." >&2
    exit 1
  }
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Personal AI Activity Collector v$VERSION"
echo "Downloading verified base runtime..."

: > "$TMP/base.b64"
for i in $(seq -w 0 14); do
  curl -fsSL "$REPO/payload/v$BASE_VERSION/part-$i.b64" >> "$TMP/base.b64"
done

base64 -d "$TMP/base.b64" > "$TMP/base.tar.xz"
BASE_ACTUAL="$(sha256sum "$TMP/base.tar.xz" | awk '{print $1}')"
if [[ "$BASE_ACTUAL" != "$BASE_SHA256" ]]; then
  echo "Error: base checksum verification failed." >&2
  echo "Expected: $BASE_SHA256" >&2
  echo "Actual:   $BASE_ACTUAL" >&2
  exit 1
fi

echo "Base checksum verified."
mkdir -p "$TMP/extract"
tar -xJf "$TMP/base.tar.xz" -C "$TMP/extract"

PACKAGE_ROOT="$TMP/extract/personal-ai-activity-collector"
if [[ ! -d "$PACKAGE_ROOT" ]]; then
  echo "Error: verified base package root was not found." >&2
  exit 1
fi

echo "Downloading verified v$VERSION audio-context update..."
: > "$TMP/overlay.b64"
for part in \
  part-00.b64 \
  part-01.b64 \
  part-02a.b64 \
  part-02b.b64 \
  part-02c.b64 \
  part-03.b64 \
  part-04a.b64 \
  part-04b.b64 \
  part-04c.b64 \
  part-05.b64; do
  curl -fsSL "$REPO/overlay/v$VERSION/$part" >> "$TMP/overlay.b64"
done

base64 -d "$TMP/overlay.b64" > "$TMP/overlay.tar.xz"
OVERLAY_ACTUAL="$(sha256sum "$TMP/overlay.tar.xz" | awk '{print $1}')"
if [[ "$OVERLAY_ACTUAL" != "$OVERLAY_SHA256" ]]; then
  echo "Error: v$VERSION overlay checksum verification failed." >&2
  echo "Expected: $OVERLAY_SHA256" >&2
  echo "Actual:   $OVERLAY_ACTUAL" >&2
  exit 1
fi

echo "v$VERSION overlay checksum verified."
tar -xJf "$TMP/overlay.tar.xz" -C "$PACKAGE_ROOT"

INSTALLER="$PACKAGE_ROOT/packaging/install.sh"
if [[ ! -f "$INSTALLER" ]]; then
  echo "Error: installer was not found in the verified package." >&2
  exit 1
fi

chmod +x "$INSTALLER"
exec "$INSTALLER"
