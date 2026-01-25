#!/bin/bash

IMAGE_NAME="localhost/h8-dev-env"

echo " H8 Development Environment Verification Script"

echo -n "[1/4] Checking if image exists... "
if podman image exists "$IMAGE_NAME"; then
    echo "OK: $IMAGE_NAME found."
else
    echo "FAILED"
    echo "Error: Image '$IMAGE_NAME' not found. Please run 'podman build' first."
    exit 1
fi

echo "[2/4] Verifying tools inside the container..."
podman run --rm "$IMAGE_NAME" bash -c '
    check_tool() {
        if command -v $1 >/dev/null 2>&1; then
            echo "  - $1: Installed ($(which $1))"
        else
            echo "  - $1: NOT FOUND"
            exit 1
        fi
    }

    check_tool h8300-elf-gcc
    check_tool h8300-elf-as
    check_tool h8300-elf-ld
    check_tool kz_h8write
    check_tool cu
'
if [ $? -ne 0 ]; then echo "Verification failed."; exit 1; fi

echo "[3/4] Checking tool versions..."
podman run --rm "$IMAGE_NAME" bash -c '
    echo -n "  - GCC version: "
    h8300-elf-gcc --version | head -n 1
    echo -n "  - Binutils version: "
    h8300-elf-as --version | head -n 1
'

echo -n "[4/4] Checking user and dialout group... "
podman run --rm "$IMAGE_NAME" bash -c '
    CURRENT_USER=$(id -un)
    if [ "$CURRENT_USER" = "ersli-osdev" ] && id -Gn | grep -q "dialout"; then
        echo "OK: User is $CURRENT_USER and belongs to dialout group."
    else
        echo "FAILED: User is $CURRENT_USER or dialout group missing."
        exit 1
    fi
'

echo " Success! Your H8 development environment is ready."
