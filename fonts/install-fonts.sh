#!/usr/bin/env bash
set -e

echo "Installing fonts..."

# Set user level fonts dir
FONT_DIR="$HOME/.local/share/fonts/iosevka"
mkdir -p "$FONT_DIR"

# Set temp working dir
TEMP=$(mktemp -d)
cd "$TEMP"

echo "Fetching latest Iosevka release info..."
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/be5invis/Iosevka/releases/latest \
		   | jq -r '
.assets[]
| select(.name | startswith("SuperTTC-Iosevka-"))
| select(.name | endswith(".zip"))
| .browser_download_url
')

if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "Error: SuperTTC-Iosevka zip not found in latest release."
    exit 1
fi

echo "Downloading SuperTTC package..."
curl -L -O "$DOWNLOAD_URL"

ZIP_FILE=$(ls SuperTTC-Iosevka-*.zip)

echo "Extracting fonts..."
unzip -q "$ZIP_FILE"

echo "Installing fonts to $FONT_DIR..."
find . -type f \( -name '*.ttc' -o -name '*.ttf' \) -exec cp {} "$FONT_DIR" \;

# refresh font cache (force, verbose)
echo "Rebuilding font cache..."
fc-cache -fv "$FONT_DIR/"

echo "Cleaning up temporary files..."
cd /
rm -rf "$TMP"

echo "Fonts installed."
