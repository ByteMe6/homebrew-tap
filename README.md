# ByteMe6/homebrew-tap

Homebrew formulae for [trackfetch](https://github.com/ByteMe6/trackfetch): a text file of songs in, tagged MP3s with cover art out.

## Install

```bash
brew install ByteMe6/tap/trackfetch
```

This also installs `deno`, `ffmpeg` and `yt-dlp`, which trackfetch needs at runtime. You still need Spotify API credentials; see [Spotify credentials](https://github.com/ByteMe6/trackfetch#spotify-credentials).

Works on macOS (Apple Silicon and Intel) and Linux (x86_64 and ARM64).

## Updates

```bash
brew update && brew upgrade trackfetch
```

The formula installs the prebuilt binaries from each [trackfetch release](https://github.com/ByteMe6/trackfetch/releases). A daily workflow picks up new releases, updates the formula and tests the install on all four platforms.

## Problems

Report problems with installing through Homebrew in this repository's [issues](https://github.com/ByteMe6/homebrew-tap/issues). Report problems with trackfetch itself in the [trackfetch repository](https://github.com/ByteMe6/trackfetch/issues).
