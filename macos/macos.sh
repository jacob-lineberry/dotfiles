#!/usr/bin/env bash
set -euo pipefail

echo "==> Applying developer macOS defaults..."

# Close System Settings to prevent it from overriding changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# --- 1. Keyboard & Input ---
echo "  [1/5] Configuring keyboard & repeat rate..."
# Disable press-and-hold for keys in favor of key repeat (crucial for Vim/Neovim hjkl navigation)
defaults write -g ApplePressAndHoldEnabled -bool false
# Set a fast key repeat rate (2 = fast, lower is faster)
defaults write -g KeyRepeat -int 2
# Set a short initial delay before repeating (12 = 180ms)
defaults write -g InitialKeyRepeat -int 12
# Enable full keyboard access for all controls (Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 3

# --- 2. Code Punctuation & Typo Prevention ---
echo "  [2/5] Disabling smart punctuation nuisances..."
# Disable automatic capitalization of first words
defaults write -g NSAutomaticCapitalizationEnabled -bool false
# Disable smart dashes (prevents --flag becoming em-dash —flag)
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
# Disable smart quotes (prevents curly quotes in code/YAML)
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable automatic spelling correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# --- 3. Dock & Mission Control ---
echo "  [3/5] Configuring Dock & Spaces..."
# Keep Dock autohidden
defaults write com.apple.dock autohide -bool true
# Remove Dock reveal delay (instant appearance on edge hover)
defaults write com.apple.dock autohide-delay -float 0
# Speed up Dock slide-in animation (0.2s)
defaults write com.apple.dock autohide-time-modifier -float 0.2
# Do not automatically rearrange Spaces based on most recent use (preserves AeroSpace workspace layout)
defaults write com.apple.dock mru-spaces -bool false

# --- 4. Finder & File Visibility ---
echo "  [4/5] Configuring Finder & file visibility..."
# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true
# Show path breadcrumb bar at the bottom
defaults write com.apple.finder ShowPathbar -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Search the current folder by default instead of "This Mac"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Use plain text mode for newly created TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Prevent Time Machine from prompting to use newly connected external drives
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# --- 5. Screenshots & Window Snappiness ---
echo "  [5/5] Configuring window animations & screenshots..."
# Disable drop shadow on window screenshots (clean crops for docs/Slack)
defaults write com.apple.screencapture disable-shadow -bool true
# Speed up window resize and modal open animations
defaults write -g NSWindowResizeTime -float 0.001

echo "==> Restarting affected services (Dock, Finder, SystemUIServer)..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "==> Done! Note: Keyboard repeat rates take effect on newly launched apps or next login."
