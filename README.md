# Personal AI Activity Collector

Local-first Linux activity collector for building a personal AI context stream.

> Use this software only on devices and accounts you own or are explicitly authorized to monitor.

## Install

### Arch Linux / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/ahmedkdbdh1354/gggt/main/install.sh | bash
```

Then launch it from anywhere:

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

## What it captures

- active application/window and presence/idle/AFK
- local filesystem/source-code changes
- terminal command structure and observed outcomes
- direct browser page/tab metadata
- semantic browser interactions: clicks, focus, hover, forms, controls, links, SPA routes
- before/after button and control states
- code editor snapshots and compiler/result output
- media play/pause/progress/ended evidence
- messaging/conversation context for the personal AI workflow

It does not record a raw key-by-key keyboard stream. Passwords, payment/card data, OTPs, cookies/session tokens, API secrets, private keys and similar credentials remain filtered.

## Browser integration

Native Messaging setup is installed automatically.

The bundled browser extension still needs to be loaded/installed in the browser. Firefox release builds require Mozilla signing for permanent installation; without signing, local testing uses `about:debugging`. Chromium-based browsers can load the bundled unpacked extension.

## Version

Current release: **v5.4.0**

Verified runtime archive SHA-256:

```text
08886dc7ce5ba3862b803b2ec4ba80c74b610244baa92c1cdda532f38cdbdd83
```

The one-command installer downloads the published payload and checks this SHA-256 before installing.

## License

No open-source license has been assigned yet. Public visibility does not grant additional reuse rights by itself.
