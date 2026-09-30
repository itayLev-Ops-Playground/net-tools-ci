#!/bin/bash

set -e

PACKAGE="net-tools"

echo "=== Updating APT package information ==="
apt update

echo "=== Downloading source package ==="
cd ~

apt-get source "$PACKAGE"

# Find the source directory created by apt-get source
SRC_DIR=$(find ~ -maxdepth 1 -type d -name "net-tools-*" | head -1)

if [[ -z "$SRC_DIR" ]]; then
    echo "ERROR: Source directory was not found"
    exit 1
fi

echo "Source directory:"
echo "$SRC_DIR"

cd "$SRC_DIR"

echo "=== Installing build dependencies ==="
apt-get build-dep -y "$PACKAGE"

echo "=== Building DEB package ==="
dpkg-buildpackage -us -uc -b

echo "=== Finding built net-tools package ==="

DEB=$(find .. -maxdepth 1 -type f \
    -name "net-tools_*.deb" \
    -print -quit)

if [[ -z "$DEB" ]]; then
    echo "ERROR: net-tools DEB package was not found"
    exit 1
fi

echo "Built DEB:"
echo "$DEB"

echo "=== Checking DEB package information ==="
dpkg-deb -I "$DEB" | grep -E 'Package:|Version:|Architecture:'

echo "=== Installing net-tools ==="
apt install -y "$DEB"

echo "=== Testing ifconfig ==="

if ifconfig; then
    echo "=== ifconfig test successful ==="
else
    echo "ERROR: ifconfig test failed"
    exit 1
fi

RELEASE="1.0.${BUILD_NUMBER}"

echo "=== Copying tested DEB to artifacts directory ==="

mkdir -p "/artifacts/build_$BUILD_NUMBER"

cp "$DEB" "/artifacts/build_$BUILD_NUMBER/"

chown "$JENKINS_UID:$JENKINS_GID" \
    "/artifacts/build_$BUILD_NUMBER/$(basename "$DEB")"

echo "Artifact:"
ls -lh "/artifacts/build_$BUILD_NUMBER/"

echo "=== Removing net-tools ==="

apt remove -y "$PACKAGE"

echo "=== Verifying removal ==="

if dpkg-query -W -f='${Status}' "$PACKAGE" 2>/dev/null | grep -q "install ok installed"; then
    echo "ERROR: net-tools is still installed"
    exit 1
else
    echo "SUCCESS: net-tools was removed"
fi

echo "=== Test completed successfully ==="
