#!/usr/bin/env python3
"""Bump Formula/trackfetch.rb to the latest trackfetch release and the latest
prebuilt ffmpeg, yt-dlp and deno binaries. Run from the repository root.

    scripts/update_formula.py            # rewrite the formula in place
    GITHUB_TOKEN=... scripts/update_formula.py
"""

import hashlib
import json
import os
import pathlib
import re
import sys
import urllib.request

FORMULA = pathlib.Path("Formula/trackfetch.rb")

# repository -> asset names the formula pins
DEPS = {
    "yt-dlp/yt-dlp": ["yt-dlp_macos"],
    "denoland/deno": ["deno-aarch64-apple-darwin.zip", "deno-x86_64-apple-darwin.zip"],
    "eugeneware/ffmpeg-static": ["ffmpeg-darwin-arm64.gz", "ffmpeg-darwin-x64.gz"],
}


def api(path):
    request = urllib.request.Request(f"https://api.github.com{path}")
    request.add_header("Accept", "application/vnd.github+json")
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        request.add_header("Authorization", f"Bearer {token}")
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.load(response)


def latest_release(repo):
    """Return (tag, {asset name: sha256}) for the latest release of repo."""
    release = api(f"/repos/{repo}/releases/latest")
    sums = {}
    for asset in release["assets"]:
        digest = asset.get("digest") or ""
        if digest.startswith("sha256:"):
            sums[asset["name"]] = digest.removeprefix("sha256:")
        else:  # very old releases only; hash the download instead
            with urllib.request.urlopen(asset["browser_download_url"], timeout=300) as download:
                sums[asset["name"]] = hashlib.sha256(download.read()).hexdigest()
    return release["tag_name"], sums


def bump(text, repo, asset, tag, digest):
    pattern = re.compile(
        rf'(url "https://github\.com/{re.escape(repo)}/releases/download/)'
        rf'[^/"]+/({re.escape(asset)}"\n\s*sha256 ")[0-9a-f]+"'
    )
    text, count = pattern.subn(rf'\g<1>{tag}/\g<2>{digest}"', text)
    if count != 1:
        sys.exit(f"{repo}/{asset}: expected one url/sha256 pair, found {count}")
    return text


def main():
    text = FORMULA.read_text()

    version, sums = latest_release("ByteMe6/trackfetch")
    for asset in (
        "trackfetch-macos-arm64",
        "trackfetch-macos-x86_64",
        "trackfetch-linux-arm64",
        "trackfetch-linux-x86_64",
    ):
        text = bump(text, "ByteMe6/trackfetch", asset, version, sums[asset])

    for repo, assets in DEPS.items():
        tag, sums = latest_release(repo)
        for asset in assets:
            text = bump(text, repo, asset, tag, sums[asset])

    if text == FORMULA.read_text():
        print("formula is already up to date")
        return

    FORMULA.write_text(text)
    print("formula updated")


if __name__ == "__main__":
    main()
