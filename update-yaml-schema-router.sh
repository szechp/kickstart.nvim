#!/usr/bin/env bash
set -e

REPO="traiproject/yaml-schema-router"
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
BINARY="${INSTALL_DIR}/yaml-schema-router"

OS="$(uname -s)"
case "${OS}" in
    Linux*)  OS_NAME="linux" ;;
    Darwin*) OS_NAME="macOS" ;;
    *)       echo "Unsupported OS: ${OS}"; exit 1 ;;
esac

ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64|amd64) ARCH_NAME="x86_64" ;;
    arm64|aarch64) ARCH_NAME="arm64" ;;
    *)             echo "Unsupported Architecture: ${ARCH}"; exit 1 ;;
esac

echo "Checking latest version..."
VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$VERSION" ]; then
    echo "Error: Could not fetch the latest version."
    exit 1
fi

echo "Latest version: ${VERSION}"

TAR_FILE="yaml-schema-router_${VERSION#v}_${OS_NAME}_${ARCH_NAME}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${TAR_FILE}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${TAR_FILE}..."
curl -sL "${DOWNLOAD_URL}" -o "${TMP_DIR}/${TAR_FILE}"

echo "Extracting to ${BINARY}..."
tar -xzf "${TMP_DIR}/${TAR_FILE}" -C "${INSTALL_DIR}" yaml-schema-router
chmod +x "${BINARY}"

echo "Successfully updated yaml-schema-router to ${VERSION}"
