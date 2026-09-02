#!/usr/bin/env bash

set -euo pipefail

MIN_COMMITS="${MIN_COMMITS:-5}"
MAX_COMMITS="${MAX_COMMITS:-10}"

if [ "$MIN_COMMITS" -gt "$MAX_COMMITS" ]; then
    echo "MIN_COMMITS cannot be greater than MAX_COMMITS"
    exit 1
fi

COUNT=$(shuf -i "${MIN_COMMITS}-${MAX_COMMITS}" -n 1)

echo "========================================"
echo "Daily Engineering Contribution Engine"
echo "========================================"
echo "Commits scheduled today: $COUNT"
echo ""

for i in $(seq 1 "$COUNT")
do
    echo "Generating contribution $i of $COUNT..."

    python3 engine/generate_entry.py

    git add daily statistics

    if git diff --cached --quiet
    then
        echo "No changes detected."
        continue
    fi

    git commit \
      -m "docs(engineering): daily knowledge entry $i/$COUNT"

    sleep 1
done

echo ""
echo "Generated commits:"
git log --oneline -n "$COUNT"

echo ""
echo "Daily contribution generation complete."
