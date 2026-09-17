# Personal AI Activity Collector

Local-first Linux activity/context collector for personal AI workflows.

Personal AI records semantic activity on your own computer — apps, browser interactions, code/editor context, media state, optional messaging context, and optional local speech-to-text audio context — and produces structured reports for later AI analysis.

> Use this software only on devices and accounts you own or are explicitly authorized to monitor.

## Install / update

### Arch Linux / Linux — one command

```bash
curl -fsSL https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main/install.sh | bash
```

Then verify/download the local audio model once:

```bash
personal-ai audio
```

Launch the app:

```bash
personal-ai
```

The installer preserves your existing `config`, `data`, `output`, `logs`, and `models` directories during upgrades.

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

## v5.7.0 fixes

This release specifically fixes the Start freeze and local audio/STT failures observed in v5.5.0:

- Start no longer runs browser/terminal setup subprocesses on Tk's UI thread.
- State changes no longer trigger expensive History/Code/Reports rescans while Start is being processed.
- Settings setup actions run in background workers instead of freezing the UI.
- Microphone input resolves to the current concrete PipeWire/PulseAudio source instead of relying on an ambiguous `default` capture target.
- System output resolves to the monitor source of the current default sink.
- Audio chunks are bounded by wall-clock time and FFmpeg is interrupted gracefully so WAV headers are finalized even when a PipeWire source is suspended.
- Input and output transcription use two Whisper workers when both streams are enabled, reducing backlog on CPU-only systems.
- Audio reports now expose the resolved devices plus the last capture/STT error for easier diagnosis.
- `personal-ai audio` now verifies FFmpeg Pulse support, the default input, the output monitor, and `whisper-cli` before reporting the audio path ready.

Verified v5.7.0 fix overlay SHA-256:

```text
7a56d2dc4db64687d35d42d85ccd9e56b5136f35e1b7ef11299eb591ac77ff24
```

## Audio Context / local Speech-to-Text

- microphone input transcript, labeled `USER_INPUT`
- system-output speech transcript from the audio you are hearing
- browser/video output classification as `BROWSER_MEDIA`
- voice-call output classification as `REMOTE_CONVERSATION` when supported by observed application context
- Spotify/music output classification as `MUSIC`
- local Whisper transcription through `whisper-cpp`; no paid AI/STT API is required

The microphone stream is a user-designated input stream, not biometric speaker identification. If another person speaks into the same microphone, the collector cannot prove who spoke based only on that stream.

For music, the collector keeps classification/timing context and does not intentionally persist verbatim song lyrics. Audio chunks are temporary working files and are removed after processing.

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

## Browser extension

The Native Messaging bridge is configured automatically by the installer.

### Firefox

The public extension is not Mozilla-signed yet. For local use:

1. Open `about:debugging`
2. Choose **This Firefox**
3. Choose **Load Temporary Add-on**
4. Select `~/.local/share/personal-ai-activity-collector/browser_extension/firefox/manifest.json`

### Chromium / Chrome / Brave

Load this directory as an unpacked extension:

```text
~/.local/share/personal-ai-activity-collector/browser_extension/chromium
```

For Native Messaging, a native browser package is recommended over sandboxed Flatpak browser builds.

## Platform

Primary target: Linux, especially Arch Linux + Wayland/Hyprland + PipeWire/Pulse compatibility. Other Linux desktops may work with reduced collector coverage.

## Version

Current public release: **v5.7.0**

The install path verifies the v5.4.0 base runtime, v5.5.0 audio-context overlay, and v5.7.0 freeze/audio fix overlay with SHA-256 before installation.

## License

No open-source license has been assigned yet. Public visibility does not grant additional reuse rights by itself.
