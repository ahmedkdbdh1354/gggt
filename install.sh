#!/usr/bin/env bash
set -Eeuo pipefail

REPO="https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main"
VERSION="5.7.0"
BASE_VERSION="5.4.0"
AUDIO_VERSION="5.5.0"
BASE_SHA256="d99f011d3bdebddc1329be61d2482e5b32b205f72364d1fe729bb82f552d2ad5"
AUDIO_SHA256="ed273fbd1ca7c8f83d075d9be6458c109a9e21080dac3f5bf52aadca4ef15a71"
FIX_SHA256="7a56d2dc4db64687d35d42d85ccd9e56b5136f35e1b7ef11299eb591ac77ff24"

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
echo "$BASE_SHA256  $TMP/base.tar.xz" | sha256sum -c -
mkdir -p "$TMP/extract"
tar -xJf "$TMP/base.tar.xz" -C "$TMP/extract"

PACKAGE_ROOT="$TMP/extract/personal-ai-activity-collector"
[[ -d "$PACKAGE_ROOT" ]] || {
  echo "Error: verified base package root was not found." >&2
  exit 1
}

echo "Downloading verified v$AUDIO_VERSION audio-context update..."
: > "$TMP/audio.b64"
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
  curl -fsSL "$REPO/overlay/v$AUDIO_VERSION/$part" >> "$TMP/audio.b64"
done
base64 -d "$TMP/audio.b64" > "$TMP/audio.tar.xz"
echo "$AUDIO_SHA256  $TMP/audio.tar.xz" | sha256sum -c -
tar -xJf "$TMP/audio.tar.xz" -C "$PACKAGE_ROOT"

echo "Downloading verified v$VERSION freeze/audio fixes..."
: > "$TMP/fix.b64"
for part in part-00.b64 part-01.b64 part-02.b64 part-03.b64; do
  curl -fsSL "$REPO/overlay/v$VERSION/$part" >> "$TMP/fix.b64"
done
base64 -d "$TMP/fix.b64" > "$TMP/fix.tar.xz"
echo "$FIX_SHA256  $TMP/fix.tar.xz" | sha256sum -c -
tar -xJf "$TMP/fix.tar.xz" -C "$PACKAGE_ROOT"

INSTALLER="$PACKAGE_ROOT/packaging/install.sh"
[[ -f "$INSTALLER" ]] || {
  echo "Error: installer was not found in the verified package." >&2
  exit 1
}

chmod +x "$INSTALLER"
exec "$INSTALLER"
