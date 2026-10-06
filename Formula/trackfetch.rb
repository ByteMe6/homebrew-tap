class Trackfetch < Formula
  desc "Turn a text file of songs into tagged MP3s with Spotify metadata"
  homepage "https://github.com/ByteMe6/trackfetch"
  version "2.0.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.0.0/trackfetch-macos-arm64"
      sha256 "71e7dadbfa436a6a567994239653b6a9b92b83d2d84d3aabbf1092b1d711b707"
    end
    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.0.0/trackfetch-macos-x86_64"
      sha256 "e51fc0a247542c4d270a7405bebdf67b7812fa68854710e42ca19eb42b9ef914"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.0.0/trackfetch-linux-arm64"
      sha256 "a731d1c93c50a6f1231310764f89afd7cd061d5f4a3a74ea3f669d9ec0ee6d27"
    end
    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.0.0/trackfetch-linux-x86_64"
      sha256 "b76de10f2541d1818b5efc1ca25894ab47e845464caf0e9cf9104cac696f33cf"
    end
  end

  depends_on "deno"
  depends_on "ffmpeg"
  depends_on "yt-dlp"

  def install
    bin.install Dir["trackfetch-*"].first => "trackfetch"
  end

  test do
    assert_match "usage: trackfetch", shell_output("#{bin}/trackfetch --help")
  end
end
