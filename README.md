# Personal AI Activity Collector

Local-first Linux activity/context collector for personal AI workflows.

Personal AI records semantic activity on your own computer — apps, browser interactions, code/editor context, media state, optional messaging context, and optional local speech-to-text audio context — and produces structured reports for later AI analysis.

> Use this software only on devices and accounts you own or are explicitly authorized to monitor.

## Install / update

### Arch Linux / Linux — one command

```bash
curl -fsSL https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main/install.sh | bash
```

Then launch it:

```bash
personal-ai
```

## Useful commands

```bash
personal-ai
personal-ai doctor
personal-ai browser
personal-ai audio
personal-ai version
personal-ai path
personal-ai uninstall
```

`personal-ai audio` checks/installs the local audio STT prerequisites and downloads the multilingual Whisper base model when it is not present yet.

The installer:

- installs required packages on Arch Linux when needed
- installs Personal AI under `~/.local/share/personal-ai-activity-collector`
- creates the `personal-ai` launcher and desktop launcher
- configures Native Messaging manifests for supported browsers
- preserves `config`, `data`, `output`, `logs`, and `models` during upgrades
- verifies the v5.4.0 base runtime and the v5.5.0 update overlay with SHA-256 before installation

## Browser extension

The Native Messaging bridge is configured automatically by the installer.

### Firefox

The public extension is not Mozilla-signed yet, so standard Firefox requires a manual temporary-add-on step for local use:

1. Open `about:debugging`
2. Choose **This Firefox**
3. Choose **Load Temporary Add-on**
4. Select:
   `~/.local/share/personal-ai-activity-collector/browser_extension/firefox/manifest.json`

### Chromium / Chrome / Brave

Load this directory as an unpacked extension:

```text
~/.local/share/personal-ai-activity-collector/browser_extension/chromium
```

For Native Messaging, a native browser package is recommended over sandboxed Flatpak browser builds.

## What v5.5.0 captures

Everything from v5.4.0, plus optional **Audio Context / local Speech-to-Text**:

- microphone input transcript, labeled `USER_INPUT`
- system-output speech transcript from the audio you are hearing
- browser/video output classification as `BROWSER_MEDIA`
- voice-call output classification as `REMOTE_CONVERSATION` when supported by the observed application context
- Spotify/music output classification as `MUSIC`
- timestamped audio context that can be correlated with browser media play/pause/seek, application switches, code/editor activity, and terminal activity
- local Whisper transcription through `whisper-cpp`; no paid AI/STT API is required

The microphone stream is a **user-designated input stream**, not biometric speaker identification. If another person speaks into the same microphone, the collector cannot prove that the voice was yours merely because it came from the input device.

For music, the collector keeps classification/timing context and does **not** intentionally persist verbatim song lyrics.

Audio chunks are temporary working files and are removed after processing; raw WAV recordings are not intended to be retained in activity reports.

## Existing context capture

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

Primary target: Linux, especially Arch Linux + Wayland/Hyprland + PipeWire/Pulse compatibility. Other Linux desktops may work with reduced collector coverage.

## Version

Current public release: **v5.5.0**

Verified base v5.4.0 runtime SHA-256:

```text
d99f011d3bdebddc1329be61d2482e5b32b205f72364d1fe729bb82f552d2ad5
```

Verified v5.5.0 runtime overlay SHA-256:

```text
ed273fbd1ca7c8f83d075d9be6458c109a9e21080dac3f5bf52aadca4ef15a71
```

## License

No open-source license has been assigned yet. Public visibility does not grant additional reuse rights by itself.
