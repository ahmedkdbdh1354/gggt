# Personal AI Activity Collector

Local-first Linux activity/context collector for personal AI workflows.

Personal AI records semantic activity on your own computer — apps, browser interactions, code/editor context, media state, and optional messaging context — and produces structured reports for later AI analysis.

> Use this software only on devices and accounts you own or are explicitly authorized to monitor.

## Install

### Arch Linux / Linux — one command

```bash
curl -fsSL https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main/install.sh | bash
```

Then launch it from any terminal:

```bash
personal-ai
```

## Useful commands

```bash
personal-ai
personal-ai doctor
personal-ai browser
personal-ai version
personal-ai path
personal-ai uninstall
```

The installer:

- installs required packages on Arch Linux when needed
- installs Personal AI under `~/.local/share/personal-ai-activity-collector`
- creates the `personal-ai` launcher
- creates a desktop launcher
- configures Native Messaging manifests for supported browsers
- preserves `config`, `data`, `output`, and `logs` during upgrades
- verifies the downloaded v5.4.0 runtime with SHA-256 before installation

## Browser extension

The Native Messaging bridge is configured automatically by the installer.

### Firefox

This public build is not Mozilla-signed yet, so standard Firefox requires a manual temporary-add-on step for local use:

1. Open `about:debugging`
2. Choose **This Firefox**
3. Choose **Load Temporary Add-on**
4. Select:
   `~/.local/share/personal-ai-activity-collector/browser_extension/firefox/manifest.json`

### Chromium / Chrome

Load this directory as an unpacked extension:

```text
~/.local/share/personal-ai-activity-collector/browser_extension/chromium
```

## What v5.4.0 captures

- foreground application/session activity
- semantic browser clicks and controls
- link targets and SPA route changes
- control state before/after, such as like, expand, checkbox, and switch
- debounced text/editor state snapshots
- code editor context
- compile/result context when directly observed
- media play/pause/progress/ended evidence
- optional messaging/conversation context
- filesystem/development activity where supported

It does not intentionally capture raw key-by-key keyboard streams, passwords, payment/card fields, OTPs, cookies/session tokens, API secrets, private keys, or similar credentials.

## Platform

Primary target: Linux, especially Arch Linux + Wayland/Hyprland. Other Linux desktops may work with reduced collector coverage.

## Version

Current public release: **v5.4.0**

Verified runtime archive SHA-256:

```text
d99f011d3bdebddc1329be61d2482e5b32b205f72364d1fe729bb82f552d2ad5
```

## License

No open-source license has been assigned yet. Public visibility does not grant additional reuse rights by itself.
