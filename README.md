# homebrew-tap

Homebrew tap for [trackfetch](https://github.com/ByteMe6/trackfetch).

## Install

```sh
brew install ByteMe6/tap/trackfetch
```

`brew install` downloads prebuilt files: trackfetch itself is never compiled, and
on macOS neither is `ffmpeg`.

- **macOS** (Apple Silicon and Intel): the formula installs the prebuilt
  `trackfetch` binary, and `ffmpeg` comes prebuilt inside the formula too, so it
  is never compiled — even on macOS versions and Intel Macs where Homebrew has
  no `ffmpeg` bottle. `yt-dlp` and `deno` are installed by Homebrew as usual.
- **Linux**: `trackfetch` comes prebuilt and `yt-dlp`, `ffmpeg` and `deno` are
  installed from Homebrew.

You'll also need Spotify API keys, [here's how to get them](https://github.com/ByteMe6/trackfetch#spotify-credentials).

## Update

```sh
brew upgrade trackfetch
```

This also refreshes the bundled `ffmpeg`. New releases land here within a day.

## Issues

- Install problems: [open an issue here](https://github.com/ByteMe6/homebrew-tap/issues)
- Anything else: [trackfetch issues](https://github.com/ByteMe6/trackfetch/issues)
