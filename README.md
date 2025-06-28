# fabric-rofi

**fabric-rofi** is a universal launcher that integrates [Fabric](https://github.com/danielmiessler/fabric) (the AI CLI) with [rofi](https://github.com/davatorium/rofi) to provide a seamless, hotkey-driven workflow for invoking AI patterns on text, code, logs, URLs, or clipboard content. Outputs are saved to Markdown files, optionally copied to clipboard, and can be opened automatically in your editor.

---

## 🔧 Features

- **Dynamic pattern discovery**: Automatically lists all installed Fabric patterns.
- **Versatile input modes**:

  - **None**: Run patterns without extra input.
  - **URL**: Fetch and process web resources (e.g., YouTube transcripts).
  - **File**: Analyze local files (logs, code, documents).
  - **Clipboard/Text**: Quickly process clipboard content or manual text.

- **Inline prompt**: Add a quick message or instruction before the main input.
- **Custom filename**: Specify your own output filename or use timestamped defaults.
- **Flexible outputs**:

  - Save results as Markdown in `~/fabric-outputs` (default).
  - Copy output to clipboard.
  - Send desktop notifications when done.
  - Open the result in your preferred editor.

- **Fallbacks**: Gracefully handles missing dependencies (`zenity`, `notify-send`).

---

## 🚀 Prerequisites

- **Bash** (>= 4.0)
- **Fabric** CLI (`fabric` in your `$PATH`)
- **rofi**
- **xclip** (for clipboard integration)
- **notify-send** (optional, for desktop notifications)
- **zenity** (optional, for progress spinner)

---

## ⚙️ Installation

1. **Copy the script** to your local bin:

   ```bash
   curl -Lo ~/.local/bin/fabric-rofi \
     https://raw.githubusercontent.com/<your-user>/<your-repo>/main/fabric-rofi
   chmod +x ~/.local/bin/fabric-rofi
   ```

2. **Ensure** `~/.local/bin` is in your `PATH`.
3. **Bind** to a hotkey in your WM (i3 example):

   ```conf
   bindsym $mod+Shift+f exec --no-startup-id ~/.local/bin/fabric-rofi
   ```

---

## 💡 Usage

```bash
fabric-rofi [options]
```

### Options

| Flag                 | Description                                                            |
| -------------------- | ---------------------------------------------------------------------- |
| `-h`, `--help`       | Show help and exit.                                                    |
| `-e`, `--editor`     | Set the editor to open outputs (default: `$EDITOR` or `nvim`).         |
| `-o`, `--output-dir` | Set custom directory for saving outputs (default: `~/fabric-outputs`). |

---

## 📋 Workflow

1. **Launch** `fabric-rofi` (via hotkey or terminal).
2. **Select** a Fabric pattern from the rofi menu.
3. **Choose** an input mode (None, URL, File, Clipboard/Text).
4. **Enter** the required input (URL, file path, or text).
5. _(Optional)_ **Type** a quick inline message to refine the prompt.
6. _(Optional)_ **Specify** a custom output filename.
7. **Decide** whether to copy to clipboard and/or send a notification.
8. **View** the progress spinner (if `zenity` is installed).
9. **Open** the resulting Markdown file in your editor.

---

## 📦 Example

1. **Summarize a YouTube lecture**:

   ```bash
   # Press Mod+Shift+f, choose "summarize_video", URL mode, paste link
   ```

2. **Analyze a log file**:

   ```bash
   # Hotkey → select "analyze_logs", File mode → choose /var/log/syslog
   ```

3. **Improve a prompt**:

   ```bash
   # Hotkey → select "improve_prompt", Clipboard/Text mode (clipboard auto-pastes)
   ```

---

## 🛠️ Customization

- **Plugins**: Extend with your own Fabric patterns in `~/.config/fabric/patterns/`.
- **UI**: Swap `rofi` for `dmenu`, or replace `zenity` with another notifier.
- **Post-processing**: Hook into your PKM system by watching the output directory.

---

## 🤝 Contributing

1. Fork the repo.
2. Create your feature branch: `git checkout -b feature/awesome`
3. Commit your changes: `git commit -m 'Add awesome feature'`
4. Push to the branch: `git push origin feature/awesome`
5. Open a pull request.
