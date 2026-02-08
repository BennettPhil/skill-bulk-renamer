#!/usr/bin/env bash

# Bulk Renamer
# Renames files based on various patterns.

set -euo pipefail

DRY_RUN=false
MODE=""
ARG1=""
ARG2=""

usage() {
  echo "Usage: $0 [OPTIONS] FILES..."
  echo "Options:"
  echo "  --prefix-date           Add YYYY-MM-DD prefix"
  echo "  --sequence PREFIX       Use sequential numbers: PREFIX-1, PREFIX-2..."
  echo "  --replace OLD NEW       Replace OLD string with NEW"
  echo "  --dry-run               Don't actually rename"
  exit 1
}

# Parse options
while [[ $# -gt 0 ]]; do
  case $1 in
    --prefix-date)
      MODE="date"
      shift
      ;;
    --sequence)
      MODE="sequence"
      ARG1="$2"
      shift 2
      ;;
    --replace)
      MODE="replace"
      ARG1="$2"
      ARG2="$3"
      shift 3
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1"
      usage
      ;;
    *)
      break
      ;;
  esac
done

FILES=("$@")

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "Error: No files specified."
  usage
fi

if [[ -z "$MODE" ]]; then
  echo "Error: No mode specified."
  usage
fi

DATE_PREFIX=$(date +%Y-%m-%d)
COUNTER=1

for file in "${FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Warning: '$file' is not a file, skipping."
    continue
  fi

  dir=$(dirname "$file")
  base=$(basename "$file")
  ext="${base##*.}"
  name="${base%.*}"

  case $MODE in
    date)
      new_name="${DATE_PREFIX}-${base}"
      ;;
    sequence)
      new_name="${ARG1}${COUNTER}.${ext}"
      ((COUNTER++))
      ;;
    replace)
      new_name="${base//$ARG1/$ARG2}"
      ;;
  esac

  if [[ "$base" == "$new_name" ]]; then
    continue
  fi

  new_path="${dir}/${new_name}"

  if $DRY_RUN; then
    echo "[DRY-RUN] Renaming $file -> $new_path"
  else
    echo "Renaming $file -> $new_path"
    mv "$file" "$new_path"
  fi
done
