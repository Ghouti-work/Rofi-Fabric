Here is your updated `README.md`, now including the new **Telos automation script** system built around Fabric + Rofi + Habitica.

---

````markdown
# fabric-rofi + telos-fabric

**fabric-rofi** is a universal launcher that integrates [Fabric](https://github.com/danielmiessler/fabric) (the AI CLI) with [rofi](https://github.com/davatorium/rofi).  
**telos-fabric** builds on top of it to automate your entire life context, using the [TELOS](https://github.com/danielmiessler/Telos) method and Fabric AI patterns.  
This system is designed for self-reflection, life engineering, habit sync, and personal OS design — all via hotkey.

---

## 🔧 Features

### 🔹 fabric-rofi

- **Dynamic pattern discovery** from your Fabric config
- Run AI tools on:
  - Local files (logs, code)
  - Clipboard or manual text
  - URLs (e.g. YouTube)
- Inline message injection before execution
- Custom filename prompts
- Markdown outputs, clipboard integration, desktop notification
- Works with any Fabric pattern

### 🔹 telos-fabric

- **Auto-creates Fabric patterns** (`telos_bullet`, `telos_section`, `telos_pentest`)
- Adds structured bullets to your Telos markdown file
- Writes to correct section (`PROBLEMS`, `GOALS`, etc.)
- Creates full sections via AI
- Runs **Life Pentest** (self-audit), stores reports in dated folder
- Extracts 3-line summary from Pentest into `Summaries` section
- **Syncs goals to Habitica** every Friday with cron

---

## 🚀 Prerequisites

- **Bash** (>= 4.0)
- **Fabric CLI** (`pip install fabric-ai`)
- **rofi**
- **xclip**, **notify-send**, **zenity** (optional)
- **curl** (for Habitica API sync)

---

## ⚙️ Installation

1. Install Fabric CLI:

   ```bash
   pip install fabric-ai
   ```
````

2. Clone or copy the `fabric-rofi` and `telos-fabric.sh` scripts into your `~/.local/bin` and make them executable:

   ```bash
   chmod +x ~/.local/bin/fabric-rofi
   chmod +x ~/.local/bin/telos-fabric.sh
   ```

3. Add keybind in your WM (i3 example):

   ```conf
   bindsym $mod+Shift+f exec --no-startup-id ~/.local/bin/fabric-rofi
   bindsym $mod+Shift+t exec --no-startup-id ~/.local/bin/telos-fabric.sh
   ```

4. Set up the cron job (optional):

   ```bash
   crontab -e
   ```

   Add this to run Habitica sync every Friday at 08:00:

   ```cron
   0 8 * * 5 ~/.local/bin/telos-fabric.sh --habitica
   ```

---

## 💡 fabric-rofi Usage

```bash
fabric-rofi [options]
```

Choose input method, pattern, and message inline.

---

## 💡 telos-fabric Usage

```bash
telos-fabric.sh
```

You'll get a rofi prompt to:

- 📌 Add Bullet (to correct section)
- 📄 Add Section (from title)
- 🛡️ Run Life Pentest (and save reports)
- 🔁 Sync to Habitica (`--habitica`)

---

## 🗂 Directory Structure

| File/Folder                                   | Purpose                     |
| --------------------------------------------- | --------------------------- |
| `~/Notes/second_brain/Telos_me.md`            | Your main TELOS file        |
| `~/Notes/second_brain/telos-pentest-reports/` | Saved life pentests         |
| `~/.config/fabric/patterns/`                  | Fabric AI pattern directory |

---

## 🌟 Example Workflows

### 1. Add Thought to "Challenges"

```bash
# Hotkey -> Add Bullet -> Input: "I keep comparing myself"
# Choose section: CHALLENGES
```

Will add:

```markdown
## CHALLENGES

- I often compare my progress to others, which triggers self-doubt...
```

### 2. Run a Pentest

```bash
# Hotkey -> Run Pentest
```

Will:

- Analyze your full `Telos_me.md`
- Save detailed feedback to `telos-pentest-reports/YYYY-MM-DD_HH-MM.md`
- Add a 3-line summary under `## Summaries`

### 3. Sync to Habitica

```bash
telos-fabric.sh --habitica
```

Pushes top 10 goals as Habitica todos via API.

---

## 🔧 Customization Ideas

- Add new patterns: `telos_goal`, `telos_value`, `telos_reflect`
- Pipe daily logs into Obsidian
- Extend with dmenu/wayland/tui support
- Track bullet usage by time/section
- Sync AI-generated tasks into your calendar

---

## 🤝 Contributing

Want to expand this into a full life OS? PRs and ideas are welcome.

---
