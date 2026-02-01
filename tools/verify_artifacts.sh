#!/bin/bash

# Artifact Integrity Verification Script
# This script ensures that binary artifacts haven't been corrupted (e.g., via LFS or transfer issues)

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$TOOLS_DIR/docker_libraries"

# Official MD5 Sums for Version 1.0.2 Dependencies
declare -A CHECKSUMS=(
    ["$LIB_DIR/boost_1_75_0.tar.bz2"]="ea217ed7c4414e93d44106c316966ae1"
    ["$LIB_DIR/cereal-1.3.0.tar.gz"]="4342e811f245403646c4175258f413f1"
    ["$LIB_DIR/chrono-8.0.0.tar.gz"]="60f00d60b9b6b9448630a4861f6d7207"
    ["$LIB_DIR/cmake-3.20.1-linux-x86_64.sh"]="a0ff175aa72cc4089e40ddefe9f14e13"
    ["$LIB_DIR/cppzmq-4.7.1.tar.gz"]="e85cf23b5aed263c2c5c89657737d107"
    ["$LIB_DIR/glm-0.9.9.5.tar.gz"]="e06e859bd80c5d6042f5c53630f385ec"
    ["$LIB_DIR/go1.17.8.linux-amd64.tar.gz"]="705413432ef6b44638474f4b8ef1da48"
    ["$LIB_DIR/googletest-release-1.10.0.tar.gz"]="ecd1fa65e7de707cd5c00bdac56022cd"
    ["$LIB_DIR/grpc-1.32.0.tar.gz"]="8fc8529605f8feb484adfb7cb283c9ab"
    ["$LIB_DIR/json-3.11.3.tar.gz"]="d603041cbc6051edbaa02ebb82cf0aa9"
    ["$LIB_DIR/jsoncpp-1.9.4.tar.gz"]="4757b26ec89798c5247fa638edfdc446"
    ["$LIB_DIR/librdkafka-1.3.0.tar.gz"]="5761fdf807b901daa721f0d505b5f924"
    ["$LIB_DIR/log4cpp-1.1.3.tar.gz"]="b9e2cee932da987212f2c74b767b4d8b"
    ["$LIB_DIR/ninja-linux.zip"]="817e12e06e2463aeb5cb4e1d19ced606"
    ["$LIB_DIR/node-v17.9.1-linux-x64.tar.xz"]="cba2b731281702b0f02c146c465adb6f"
    ["$LIB_DIR/pugixml-1.11.1.tar.gz"]="71c5fcf9d11b92e1ed751b31ffffbebb"
    ["$LIB_DIR/Python-3.9.4.tgz"]="cc8507b3799ed4d8baa7534cd8d5b35f"
    ["$LIB_DIR/soci-4.0.1.tar.gz"]="0f8a55ea9672d282cb167f8f70b3765b"
    ["$LIB_DIR/sqlite-amalgamation-3340100.zip"]="fc92d9275d9baa483c7199f44b86d4ae"
    ["$LIB_DIR/tinyxml2-7.0.1.tar.gz"]="bc3c806033a2cb426db0fdb75e5b1bf2"
    ["$LIB_DIR/uriparser-0.9.6.tar.gz"]="ff68494eb7ef3fb09effe94c2e1a92ac"
    ["$LIB_DIR/zeromq-4.3.4.tar.gz"]="c897d4005a3f0b8276b00b7921412379"
)

echo "Starting artifact integrity verification..."
FAILED=0

for FILE_PATH in "${!CHECKSUMS[@]}"; do
    FILE=$(basename "$FILE_PATH")

    # In Docker, files are copied to current dir. Check there if full path doesn't exist.
    CHECK_PATH="$FILE_PATH"
    if [ ! -f "$CHECK_PATH" ]; then
        if [ -f "./$FILE" ]; then
            CHECK_PATH="./$FILE"
        else
            echo "[MISSING] $FILE"
            FAILED=1
            continue
        fi
    fi

    ACTUAL_MD5=$(md5sum "$CHECK_PATH" | awk '{print $1}')
    EXPECTED_MD5="${CHECKSUMS[$FILE_PATH]}"

    if [ "$ACTUAL_MD5" != "$EXPECTED_MD5" ]; then
        echo "[CORRUPT] $FILE (Expected: $EXPECTED_MD5, Actual: $ACTUAL_MD5)"
        FAILED=1
    else
        echo "[OK] $FILE"
    fi
done

if [ $FAILED -ne 0 ]; then
    echo "ERROR: Artifact verification failed. Some files are missing or corrupted."
    exit 1
fi

echo "All artifacts verified successfully."
exit 0
