# homebrew-tap

Homebrew tap for [trackfetch](https://github.com/ByteMe6/trackfetch).

## Install

```sh
brew install ByteMe6/tap/trackfetch
```

`brew install` only downloads files, it never compiles anything.

- **macOS** (Apple Silicon and Intel): the formula installs the prebuilt
  `trackfetch` binary plus prebuilt `yt-dlp`, `ffmpeg` and `deno` inside the
  formula. You don't need them in your `PATH`, and there is no source build even
  on macOS versions Homebrew has no bottles for.
- **Linux**: `trackfetch` comes prebuilt and `yt-dlp`, `ffmpeg` and `deno` are
  installed from Homebrew.

You'll also need Spotify API keys, [here's how to get them](https://github.com/ByteMe6/trackfetch#spotify-credentials).

## Update

```sh
brew upgrade trackfetch
```

This also refreshes the bundled `yt-dlp`, `ffmpeg` and `deno`. New releases land
here within a day.

## Issues

- Install problems: [open an issue here](https://github.com/ByteMe6/homebrew-tap/issues)
- Anything else: [trackfetch issues](https://github.com/ByteMe6/trackfetch/issues)
