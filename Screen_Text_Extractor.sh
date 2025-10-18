#!/bin/bash

# ===============================================
# OCR Screenshot Setup Script for Ubuntu
# ===============================================
# This script will:
# 1. Install required tools for OCR screenshots
# 2. Provide a ready-to-use OCR screenshot command
# 3. Show instructions to add a custom keyboard shortcut
# ===============================================

echo "=============================================="
echo "Step 1: Installing required tools..."
echo "----------------------------------------------"

sudo apt update
sudo apt install -y gnome-screenshot tesseract-ocr xclip imagemagick

echo
echo "=============================================="
echo "Step 2: OCR Screenshot Command"
echo "----------------------------------------------"
echo "This command allows you to:"
echo " - Select a region of your screen"
echo " - Extract text from the screenshot using OCR"
echo " - Copy the extracted text directly to your clipboard"
echo " - Automatically remove the temporary screenshot"
echo
echo "Optimized one-liner command:"
echo
echo "bash -c 'tmp=\$(mktemp --suffix=.png); gnome-screenshot -a -f \"\$tmp\"; convert \"\$tmp\" -density 300 -colorspace Gray -contrast-stretch 0 \"\$tmp\"; tesseract \"\$tmp\" stdout -l eng | xclip -selection clipboard; rm -f \"\$tmp\"'"
echo
echo "=============================================="
echo "Step 3: Adding a Custom Keyboard Shortcut"
echo "----------------------------------------------"
echo "1. Open Settings → Keyboard → Keyboard Shortcuts → Custom Shortcuts"
echo "2. Click '+' to add a new shortcut"
echo "3. Name: OCR Screenshot"
echo "4. Command (copy/paste the optimized one-liner above):"
echo
echo "   bash -c 'tmp=\$(mktemp --suffix=.png); gnome-screenshot -a -f \"\$tmp\"; convert \"\$tmp\" -density 300 -colorspace Gray -contrast-stretch 0 \"\$tmp\"; tesseract \"\$tmp\" stdout -l eng | xclip -selection clipboard; rm -f \"\$tmp\"'"
echo "   bash -c 'tmp=$(mktemp --suffix=.png); gnome-screenshot -a -f "$tmp"; convert "$tmp" -density 600 -resize 300% -colorspace Gray -contrast-stretch 0 -sharpen 0x1 "$tmp"; tesseract "$tmp" stdout -l eng --oem 1 --psm 6 | xclip -selection clipboard; rm -f "$tmp"'"
echo
echo "5. Assign your preferred key combo (e.g., Ctrl+Shift+O)"
echo "6. Test: Press your shortcut, select a screen area, then paste text from clipboard"
echo
echo "=============================================="
echo "Optional Tips:"
echo "- The screenshot is temporary and is removed automatically"
echo "- You can change the temp folder by editing the 'tmp' variable in the command"
echo "- Ensure 'xclip' works with your clipboard (Clipboard Indicator extension is compatible)"
echo "- You can change '-l eng' to another language if needed (check 'tesseract --list-langs')"
echo "=============================================="

echo
echo "Setup Complete! You can now use OCR screenshots via terminal or custom shortcut."
