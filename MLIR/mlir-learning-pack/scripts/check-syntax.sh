#!/usr/bin/env bash
set -euo pipefail

if ! command -v mlir-opt >/dev/null 2>&1; then
  echo "mlir-opt was not found in PATH. Build MLIR or add llvm-project/build/bin to PATH." >&2
  exit 1
fi

for f in examples/*.mlir pow/*.mlir; do
  echo "checking $f"
  mlir-opt --verify-diagnostics "$f" >/dev/null
done

echo "All MLIR files parsed successfully."
