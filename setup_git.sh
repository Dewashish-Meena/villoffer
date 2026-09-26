#!/bin/bash
cd /c/Data/learning/deepseekharness/workspace/city-offers-marketplace

# Set git user
git config user.name "Dewashish-Meena"
git config user.email "contact@dewashish.meena"

# Add remote
git remote add origin https://github.com/Dewashish-Meena/city-offers-marketplace.git 2>/dev/null || true

# Rename branch
git branch -M main 2>/dev/null || true

# Commit
git commit -am "Initial project structure - Flutter mobile, React web, Express backend, Admin console" --author="Dewashish-Meena <contact@dewashish.meena>"

# Push
git push -u origin main

echo "Done!"
