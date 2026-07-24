#!/usr/bin/env bash

set -euo pipefail

PROJECT=$(pwd)

# Check dependencies
for cmd in autoconf riscv64-unknown-elf-objcopy; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd not found in PATH" >&2
    exit 1
  fi
done

# Clone
rm -rf ./riscv-tests ./raw ./elf
git clone https://github.com/riscv/riscv-tests.git
cd riscv-tests
git submodule update --init --recursive

# Build rv32i
autoreconf -i
./configure --with-xlen=32 --with-arch=rv32i --with-abi=ilp32
make -j"$(nproc)" isa

echo "MAKE COMPLETE"

# Extract
cd "$PROJECT"
mkdir -pv elf raw

# Copy binaries and dump files to elf/
cp -v riscv-tests/isa/rv32ui-p-* ./elf/

# Convert binaries (excluding .dump files) to raw/
find ./elf -type f ! -name "*.dump" -exec sh -c '
  for file; do
    name=$(basename "$file")
    echo "processing $file -> raw/$name.bin"
    riscv64-unknown-elf-objcopy -O binary -j .text.init "$file" "raw/$name.bin"
  done
' sh {} +
