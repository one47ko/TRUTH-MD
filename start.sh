#!/bin/bash
  # TRUTH-MD Auto-Start Script
  # Runs on every panel startup: updates code, installs deps, starts bot

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "      TRUTH-MD STARTUP SEQUENCE"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # 1. Auto-pull latest code from GitHub
  echo "🔄 Pulling latest updates from GitHub..."
  git pull origin main 2>/dev/null && echo "✅ Code updated" || echo "⚠️  Could not pull (using local files)"

  # 2. Install/fix dependencies automatically
  echo "📦 Installing dependencies..."
  npm install --legacy-peer-deps --prefer-offline 2>/dev/null || npm install --legacy-peer-deps

  # 3. Run Baileys patch if it exists
  if [ -f "scripts/patch-baileys.js" ]; then
    echo "🔧 Patching Baileys..."
    node scripts/patch-baileys.js 2>/dev/null || true
  elif [ -f "patch-baileys.cjs" ]; then
    node patch-baileys.cjs 2>/dev/null || true
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🚀 Starting TRUTH-MD..."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # 4. Start the bot
  node index.js
  