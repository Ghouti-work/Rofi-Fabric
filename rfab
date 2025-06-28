#!/usr/bin/env bash
# fabric-rofi: universal Fabric launcher via rofi
# Usage: fabric-rofi [options]
# Options:
#   -h, --help           Show this help message and exit
#   -e, --editor         Specify editor to open output (default: $EDITOR or nvim)
#   -o, --output-dir     Directory to save output files (default: ~/fabric-outputs)

# Default configurations
OUTPUT_DIR=~/Notes/fabric-outputs
EDITOR=${EDITOR:-nvim}

# Print help message
print_help() {
  sed -n '1,12p' "$0"
  echo
  echo "This script discovers all Fabric patterns, lets you choose via rofi,"
  echo "prompts for input type, optional quick message, runs the selected pattern, and handles output."
  echo
  echo "By default, outputs are saved under: $OUTPUT_DIR"
  echo
  echo "You can customize the editor and output directory with flags."
  exit 0
}

# Parse arguments
while [[ "$1" =~ ^- ]]; do
  case "$1" in
    -h|--help)
      print_help
      ;;
    -e|--editor)
      shift
      EDITOR="$1"
      ;;
    -o|--output-dir)
      shift
      OUTPUT_DIR="$1"
      ;;
    *)
      echo "Unknown option: $1" >&2
      print_help
      ;;
  esac
  shift
done

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Check for zenity
if ! command -v zenity &> /dev/null; then
  USE_ZENITY=false
else
  USE_ZENITY=true
fi

# 1. Discover all patterns
mapfile -t PATTERNS < <(fabric -l | sed '1d' | awk '{print $1}')
# mapfile -t PATTERNS loads them into a Bash array.

# 2. Let user pick a pattern
CHOICE=$(printf "%s
" "${PATTERNS[@]}" | rofi -dmenu -i -p "Fabric Pattern:")
[ -z "$CHOICE" ] && exit 0

# 3. Choose input mode
INPUT_MODE=$(printf "⦿ None
⦿ URL
⦿ File
⦿ Clipboard/Text" \
  | rofi -dmenu -i -p "Input type:")
[ -z "$INPUT_MODE" ] && exit 0

# 4. Gather argument or stdin
ARGS=""
case "$INPUT_MODE" in
  *URL*)
    ARGS=$(rofi -dmenu -p "Enter URL:")
    ;;
  *File*)
    if command -v rofi-file-browser >/dev/null; then
      ARGS=$(rofi-file-browser --show-files)
    else
      ARGS=$(find ~ -type f | rofi -dmenu -i -p "Select file:")
    fi
    ;;
  *Clipboard/Text*)
    ARGS=$((xclip -o 2>/dev/null) || rofi -dmenu -p "Enter text:")
    ;;
  *) ;;
esac

# 5. Optional quick message for fast prompts
MESSAGE=$(rofi -dmenu -p "Quick message/inline prompt (optional):")

# 6. Ask custom filename
CUSTOM_NAME=$(rofi -dmenu -p "Output filename (without extension, optional):")

# 7. Choose output sinks
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SAFE_CHOICE=${CHOICE//[^a-zA-Z0-9_-]/_}
if [[ -n "$CUSTOM_NAME" ]]; then
  SAVE_FILE="$OUTPUT_DIR/${CUSTOM_NAME}.md"
else
  SAVE_FILE="$OUTPUT_DIR/fabric-output-${SAFE_CHOICE}-${TIMESTAMP}.md"
fi

CLIP=$(printf "Yes
No" | rofi -dmenu -p "Copy to clipboard?")
NOTIFY=$(printf "Yes
No" | rofi -dmenu -p "Notify when done?")

# 8. Run Fabric with or without zenity spinner
run_and_capture() {
  if [[ -n "$MESSAGE" ]]; then
    INPUT_PIPE=$(printf "%s %s" "$MESSAGE" "$ARGS")
    echo "$INPUT_PIPE" | run_fabric > "$SAVE_FILE"
  else
    run_fabric > "$SAVE_FILE"
  fi
}

run_fabric() {
  case "$INPUT_MODE" in
    *URL*)    fabric -y "$ARGS" -p "$CHOICE" ;;
    *File*)   fabric -p "$CHOICE" < "$ARGS" ;;
    *Clipboard/Text*)  printf "%s" "$ARGS" | fabric -p "$CHOICE" ;;
    *)        fabric -p "$CHOICE" ;;
  esac
}

if $USE_ZENITY; then
  (
    echo "0"
    run_and_capture
    echo "100"
  ) | zenity --progress --pulsate --title="Fabric: $CHOICE" --auto-close
else
  echo "Running Fabric: $CHOICE..."
  run_and_capture
fi

# 9. Handle outputs
if [[ "$CLIP" == "Yes" ]]; then
  xclip -selection clipboard < "$SAVE_FILE"
fi

if [[ "$NOTIFY" == "Yes" ]]; then
  if command -v notify-send &> /dev/null; then
    notify-send "Fabric: $CHOICE" "Output saved to: $SAVE_FILE"
  else
    echo "Notification: Output saved to $SAVE_FILE"
  fi
fi

# 10. Offer to open the file
if printf "Open in editor?\nYes\nNo" | rofi -dmenu -p "Done:" | grep -q Yes; then
  "$EDITOR" "$SAVE_FILE"
fi

exit 0


