# extract-test-blobs

Clones [riscv-tests](https://github.com/riscv/riscv-tests), builds the RV32I user-level ISA test suite, and extracts the `.text.init` sections as raw binary blobs.

## Dependencies

- `autoconf`
- `riscv64-unknown-elf-objcopy` (from a RISC-V binutils installation)

## Usage

```sh
./go.sh
```

Output:

- `elf/` — copied ELF binaries and `.dump` files from `riscv-tests/isa/`
- `raw/` — raw binary blobs extracted from the `.text.init` section of each test

## Cleaning

```sh
rm -rf riscv-tests elf raw
```