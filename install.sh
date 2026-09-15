#!/usr/bin/env bash
set -Eeuo pipefail

REPO="ahmedkdbdh1354/gggt"
BRANCH="main"
EXPECTED_SHA256="08886dc7ce5ba3862b803b2ec4ba80c74b610244baa92c1cdda532f38cdbdd83"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

need_tools=(curl base64 sha256sum tar xz)
missing=0
for cmd in "${need_tools[@]}"; do
  command -v "$cmd" >/dev/null 2>&1 || missing=1
done

if (( missing )); then
  if command -v pacman >/dev/null 2>&1; then
    echo "Installing installer dependencies..."
    sudo pacman -S --needed --noconfirm curl coreutils tar xz
  else
    echo "Missing required tools: curl, base64, sha256sum, tar, xz" >&2
    echo "Install them with your distribution package manager and retry." >&2
    exit 1
  fi
fi

BASE="https://raw.githubusercontent.com/$REPO/$BRANCH/payload"
: > "$TMP/runtime.b64"

for i in 00 01 02 03 04 05 06 07 08 09; do
  n=$((10#$i + 1))
  printf 'Downloading Personal AI payload %d/10...\n' "$n"
  curl --fail --silent --show-error --location \
    "$BASE/runtime-part-$i.b64" >> "$TMP/runtime.b64"
done

base64 -d "$TMP/runtime.b64" > "$TMP/personal-ai-runtime.tar.xz"

ACTUAL_SHA256="$(sha256sum "$TMP/personal-ai-runtime.tar.xz" | awk '{print $1}')"
if [[ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]]; then
  echo "Checksum verification failed." >&2
  echo "Expected: $EXPECTED_SHA256" >&2
  echo "Actual:   $ACTUAL_SHA256" >&2
  exit 1
fi

echo "Checksum verified."
mkdir -p "$TMP/app"
tar -xJf "$TMP/personal-ai-runtime.tar.xz" -C "$TMP/app"

INSTALLER="$TMP/app/personal-ai-activity-collector/packaging/install.sh"
if [[ ! -f "$INSTALLER" ]]; then
  echo "Installer entry point was not found in the verified archive." >&2
  exit 1
fi

exec bash "$INSTALLER"
