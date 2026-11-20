#!/usr/bin/env bash
set -euo pipefail

echo "==> Reverting macOS defaults to pre-script baseline..."

# Close System Settings to prevent conflicts
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# --- 1. Keyboard & Input (reset to defaults) ---
echo "  [1/5] Restoring keyboard defaults..."
defaults delete -g ApplePressAndHoldEnabled 2>/dev/null || true
defaults delete -g KeyRepeat 2>/dev/null || true
defaults delete -g InitialKeyRepeat 2>/dev/null || true
defaults delete -g AppleKeyboardUIMode 2>/dev/null || true

# --- 2. Code Punctuation (restore pre-script state) ---
echo "  [2/5] Restoring text & smart punctuation..."
# NSAutomaticCapitalizationEnabled was explicitly 1 in baseline
defaults write -g NSAutomaticCapitalizationEnabled -bool true
defaults delete -g NSAutomaticDashSubstitutionEnabled 2>/dev/null || true
defaults delete -g NSAutomaticQuoteSubstitutionEnabled 2>/dev/null || true
defaults delete -g NSAutomaticSpellingCorrectionEnabled 2>/dev/null || true

# --- 3. Dock & Mission Control ---
echo "  [3/5] Restoring Dock defaults..."
# autohide was explicitly 1 in baseline
defaults write com.apple.dock autohide -bool true
defaults delete com.apple.dock autohide-delay 2>/dev/null || true
defaults delete com.apple.dock autohide-time-modifier 2>/dev/null || true
defaults delete com.apple.dock mru-spaces 2>/dev/null || true

# --- 4. Finder & File Visibility ---
echo "  [4/5] Restoring Finder defaults..."
defaults delete com.apple.finder AppleShowAllFiles 2>/dev/null || true
defaults delete -g AppleShowAllExtensions 2>/dev/null || true
defaults delete com.apple.finder ShowPathbar 2>/dev/null || true
defaults delete com.apple.finder FXEnableExtensionChangeWarning 2>/dev/null || true
defaults delete com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null || true
defaults delete com.apple.desktopservices DSDontWriteUSBStores 2>/dev/null || true
defaults delete com.apple.finder FXDefaultSearchScope 2>/dev/null || true
defaults delete com.apple.TextEdit RichText 2>/dev/null || true
defaults delete com.apple.TimeMachine DoNotOfferNewDisksForBackup 2>/dev/null || true

# --- 5. Screenshots & Window Snappiness ---
echo "  [5/5] Restoring screenshot & window defaults..."
defaults delete com.apple.screencapture disable-shadow 2>/dev/null || true
defaults delete -g NSWindowResizeTime 2>/dev/null || true

echo "==> Restarting affected services..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "==> Revert complete! Factory defaults restored."
