#!/usr/bin/env bash
# buildx-local.sh — multi-arch node builds (regular & full), tags match the directory name

# 1) Defaults (before set -u to avoid unbound vars)
PLATFORMS="linux/amd64,linux/arm64"
TARGET_TYPE=""
TARGET_VERSION=""
FORCE_BUILD=false
BUILD_ALL=false

# Determine date command (macOS support)
DATE_CMD=date
if [[ "$(uname)" == "Darwin" ]]; then
  if command -v gdate >/dev/null 2>&1; then
    DATE_CMD=gdate
  else
    echo "Error: GNU date (gdate) is required on macOS. Install via 'brew install coreutils'." >&2
    exit 1
  fi
fi

# 2) Strict mode
set -euo pipefail

# 3) Cleanup on exit
cleanup() {
  echo "Cleaning up buildx builder & context…" >&2
  docker buildx use default >/dev/null 2>&1 || true
  docker buildx rm builder   >/dev/null 2>&1 || true
  docker context rm builder   >/dev/null 2>&1 || true
}
trap cleanup EXIT

# 4) QEMU + Buildx setup
docker run --rm --privileged tonistiigi/binfmt --install all
docker context inspect builder >/dev/null 2>&1 || docker context create builder
docker buildx create builder --use --bootstrap

# 5) Parse flags
while [[ $# -gt 0 ]]; do
  case $1 in
    --type)     TARGET_TYPE="$2"; shift 2 ;;
    --version)  TARGET_VERSION="$2"; shift 2 ;;
    --all)      BUILD_ALL=true;            shift ;;
    --force)    FORCE_BUILD=true;          shift ;;
    --platform) PLATFORMS="$2";            shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

# 6) Determine matrix
ALL_TYPES=(regular full)
ALL_VERSIONS=(14 16 18 20 22)

if   $BUILD_ALL; then
  TYPES=("${ALL_TYPES[@]}")
  VERSIONS=("${ALL_VERSIONS[@]}")
elif [[ -n "$TARGET_TYPE" && -n "$TARGET_VERSION" ]]; then
  TYPES=("$TARGET_TYPE")
  VERSIONS=("$TARGET_VERSION")
elif [[ -n "$TARGET_VERSION" ]]; then
  TYPES=("${ALL_TYPES[@]}")
  VERSIONS=("$TARGET_VERSION")
elif [[ -n "$TARGET_TYPE" ]]; then
  TYPES=("$TARGET_TYPE")
  VERSIONS=("${ALL_VERSIONS[@]}")
else
  echo "Error: must specify --all or at least one of --type/--version" >&2
  exit 1
fi

# 7) Fail fast if no matching dirs
found=0
for v in "${VERSIONS[@]}"; do
  for t in "${TYPES[@]}"; do
    if [[ "$t" == "regular" ]]; then
      [[ -f "$v/Dockerfile" ]] && found=1
    elif [[ "$t" == "full" ]]; then
      [[ -f "$v-full/Dockerfile" ]] && found=1
    fi
  done
done
if (( found == 0 )); then
  echo "Error: no matching directories for version(s): ${VERSIONS[*]}" >&2
  exit 1
fi

# 8) Helper: skip if built <24h ago
was_recent() {
  local img="$1"
  local created
  created=$(
    docker inspect --format '{{.Created}}' "$img" 2>/dev/null \
    || return 1
  )
  local csec=$($DATE_CMD --date="$created" +%s)
  local now=$($DATE_CMD +%s)
  (( now - csec < 86400 ))
}

# 9) Build loop
for v in "${VERSIONS[@]}"; do
  for t in "${TYPES[@]}"; do
    if [[ "$t" == "regular" ]]; then
      DIR="$v"
      TAG="mxmd/node:${v}"
    elif [[ "$t" == "full" ]]; then
      DIR="$v-full"
      TAG="mxmd/node${v}-full"
    fi
    
    [[ ! -f "$DIR/Dockerfile" ]] && continue

    # Skip if fresh and not forced
    if [[ "$FORCE_BUILD" != "true" ]] && was_recent "$TAG"; then
      echo "Skipping $TAG (built <24h ago)" >&2
      continue
    fi

    echo "Building $TAG for $PLATFORMS" >&2
    if [[ "$PLATFORMS" == *","* ]]; then
      echo "Multi-platform build detected, using --push instead of --load"
      docker buildx build \
        --push \
        --platform "$PLATFORMS" \
        --tag "$TAG" \
        --file "$DIR/Dockerfile" \
        .
    else
      docker buildx build \
        --load \
        --platform "$PLATFORMS" \
        --tag "$TAG" \
        --file "$DIR/Dockerfile" \
        .
    fi
  done
done
