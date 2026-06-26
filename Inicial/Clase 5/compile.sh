#!/bin/bash
# Compile slides.md to PDF, HTML, or PPTX
# Usage: ./compile.sh [pdf|html|pptx]
# Requires: marp-cli (npx @marp-team/marp-cli)

FORMAT="${1:-pdf}"
npx @marp-team/marp-cli slides.md \
  --theme cipc.css \
  --"$FORMAT" \
  --html --allow-local-files

