#!/bin/bash
# 一键部署到 GitHub Pages
cd "$(dirname "$0")"
git add -A
git commit -m "Auto deploy: $(date '+%Y-%m-%d %H:%M')"
git push
echo ""
echo "https://nqn7m1-010.github.io/microbiology-review/"
