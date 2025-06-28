#!/usr/bin/env bash

# =============================
# TELOS-FABRIC SYSTEM SCRIPT
# Author: ghouti (via ChatGPT)
# Description: Automates bullet insertion, section creation,
# AI-driven life pentesting, and Habitica sync.
# =============================

# --- User Config ---
TEL="$HOME/Notes/second_brain/Telos_me.md"
PENTEST_DIR="$HOME/Notes/second_brain/telos-pentest-reports"
EDITOR=${EDITOR:-nvim}
FABRIC_DIR="$HOME/.config/fabric/patterns"
HABITICA_USER_ID="0"
HABITICA_API_TOKEN=""

mkdir -p "$FABRIC_DIR" "$PENTEST_DIR"

# --- Install Fabric Patterns ---
install_pattern() {
  local name=$1 content=$2
  local dir="${FABRIC_DIR}/${name}"
  local path="${dir}/system.md"
  [[ -f "$path" ]] && return
  mkdir -p "$dir"
  echo "$content" >"$path"
  echo "✅ Installed Fabric pattern: $name"
}

install_pattern "telos_bullet" "# pattern: telos_bullet
# description: Expand a short idea into a reflective bullet.
Prompt:
Reflect on the following personal note. Rewrite it as a clear, short, honest Telos bullet (1 paragraph max):
{stdin}"

install_pattern "telos_section" "# pattern: telos_section
# description: Generate markdown section for Telos.
Prompt:
You are helping expand a Telos document. Write a 3–5 paragraph markdown section titled: {stdin}.
Then add 2–3 bullet takeaways at the end."

install_pattern "telos_pentest" "# pattern: telos_pentest
# description: Pentest a Telos document for blind spots.
Prompt:
You are an AI red-teamer. Analyze the full Telos document below.
Return key risks, weak spots, contradictions, and missed opportunities. Under 250 words.
{stdin}"

# --- Utility Functions ---

add_bullet_to_section() {
  local prompt="$1"
  local section="$2"
  local output
  output=$(echo "$prompt" | fabric -p telos_bullet)

  if ! grep -q "## $section" "$TEL"; then
    echo -e " ## $section " >>"$TEL"
  fi

  awk -v s="## $section" -v o="- $output" '
    BEGIN { added=0 }
    {
      print $0
      if (!added && $0 == s) {
        print o
        added=1
      }
    }
  ' "$TEL" >"$TEL.tmp" && mv "$TEL.tmp" "$TEL"

  notify-send "Telos Updated" "Bullet added to $section"
}

run_pentest() {
  local full_out summary path
  full_out=$(fabric -p telos_pentest <"$TEL")
  summary=$(echo "$full_out" | head -n 5 | tr '\n' ' ' | cut -c 1-280)

  local ts=$(date +%F_%H-%M)
  path="$PENTEST_DIR/pentest_${ts}.md"
  echo -e "## 🛡️ Life Pentest — $ts

$full_out" >"$path"

  if ! grep -q "## Summaries" "$TEL"; then
    echo -e " ## Summaries " >>"$TEL"
  fi

  if ! grep -q "$summary" "$TEL"; then
    echo "- 🔍 $summary" >>"$TEL"
  fi

  notify-send "Telos Pentest" "Report saved to $path"
}

create_habitica_tasks() {
  goals=$(awk '/## GOALS/,/^##/' "$TEL" | grep '^-' | sed 's/^- //' | head -10)
  for goal in $goals; do
    curl -s -X POST https://habitica.com/api/v3/tasks/user -H "x-api-user: $HABITICA_USER_ID" -H "x-api-key: $HABITICA_API_TOKEN" -H "Content-Type: application/json" -d "{"text":"$goal","type":"todo"}" >/dev/null
  done
  notify-send "Habitica Sync" "Synced top goals to Habitica"
}

# --- Main Interactive Flow ---

if [[ "$1" == "--habitica" ]]; then
  create_habitica_tasks
  exit 0
fi

ACTION=$(printf "• Add Bullet\n• Add Section\n• Run Pentest" | rofi -dmenu -i -p "Telos Action:")
[[ -z "$ACTION" ]] && exit 0

case "$ACTION" in
*Bullet)
  prompt=$(rofi -dmenu -p "Bullet Thought:")
  section=$(printf "PROBLEMS\nGOALS\nCHALLENGES\nIDEAS\nWISDOM\nTRAUMAS" | rofi -dmenu -p "Target Section:")
  [[ -z "$prompt" || -z "$section" ]] && exit 1
  add_bullet_to_section "$prompt" "$section"
  ;;
*Section)
  title=$(rofi -dmenu -p "Section Title:")
  [[ -z "$title" ]] && exit 1
  out=$(echo "$title" | fabric -p telos_section)
  echo -e "\n## $title\n\n$out" >>"$TEL"
  notify-send "Telos Updated" "Added section $title"
  ;;
*Pentest)
  run_pentest
  ;;
esac

"$EDITOR" "$TEL"
