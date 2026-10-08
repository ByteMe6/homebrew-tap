# homebrew-tap

Homebrew tap for [trackfetch](https://github.com/ByteMe6/trackfetch).

## Install

```sh
brew install ByteMe6/tap/trackfetch
```

This pulls in `yt-dlp`, `ffmpeg` and `deno` too. You'll also need Spotify API keys, [here's how to get them](https://github.com/ByteMe6/trackfetch#spotify-credentials).

Works on macOS and Linux, both Intel and ARM.

**Intel Mac:** Homebrew no longer has prebuilt `yt-dlp`, `ffmpeg` and `deno` for Intel, so the first install builds them from source. It takes a while.

## Update

```sh
brew upgrade trackfetch
```

New trackfetch releases land here within a day.

## Issues

- Install problems: [open an issue here](https://github.com/ByteMe6/homebrew-tap/issues)
- Anything else: [trackfetch issues](https://github.com/ByteMe6/trackfetch/issues)
