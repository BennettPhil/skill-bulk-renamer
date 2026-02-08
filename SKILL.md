---
name: bulk-renamer
description: A tool for renaming files in bulk with date prefixes, sequential numbers, or string replacements.
version: 0.1.0
license: Apache-2.0
---

# Bulk Renamer

## Purpose
This skill allows you to rename multiple files in a directory at once. It supports adding date prefixes, sequential numbering, and basic string replacement. It's useful for organizing image folders, logs, or any collection of files that need consistent naming.

## Quick Start

```bash
# Add a date prefix to all .jpg files in the current directory
$ ./scripts/run.sh --prefix-date *.jpg
Renaming image1.jpg -> 2026-02-08-image1.jpg
...
```

## Usage Examples

### Example: Sequential Numbering

```bash
$ ./scripts/run.sh --sequence "photo-" *.png
Renaming img_01.png -> photo-1.png
Renaming img_02.png -> photo-2.png
```

### Example: String Replacement

```bash
$ ./scripts/run.sh --replace "old" "new" *.txt
Renaming old_file.txt -> new_file.txt
```

## Smoke Tests

```bash
#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0
check() {
  local desc="$1" condition="$2"
  if eval "$condition"; then
    ((PASS++)); echo "PASS: $desc"
  else
    ((FAIL++)); echo "FAIL: $desc"
  fi
}

# Setup test files
mkdir -p test_files
touch test_files/a.tmp test_files/b.tmp

# Test sequence
./scripts/run.sh --sequence "test-" test_files/*.tmp > /dev/null
check "sequence check" "[ -f test_files/test-1.tmp ] && [ -f test_files/test-2.tmp ]"

# Cleanup
rm -rf test_files

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
```

## Options Reference

| Flag | Default | Description |
|------|---------|-------------|
| `--prefix-date` | - | Add YYYY-MM-DD prefix |
| `--sequence` | - | Use sequential numbers with given prefix |
| `--replace` | - | Replace OLD with NEW |
| `--dry-run` | false | Show what would happen without renaming |

## Error Handling

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Usage error |
| 2 | Runtime error |
