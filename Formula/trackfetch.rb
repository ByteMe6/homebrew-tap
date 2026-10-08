class Trackfetch < Formula
  desc "Turn a text file of songs into tagged MP3s with Spotify metadata"
  homepage "https://github.com/ByteMe6/trackfetch"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.1.0/trackfetch-macos-arm64"
      sha256 "ad13b40f45e9fc994e6934eefd1692a8f6503c4ccc016473aed678214800c0d3"
    end
    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.1.0/trackfetch-macos-x86_64"
      sha256 "b4e930f1150eb32d23d366ef26f9b0f7540ec9994232cb5441547c6ba9793f6e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.1.0/trackfetch-linux-arm64"
      sha256 "9854308ea75c45596f8a899dc755c12e60beeb93e6e4c6f4f5fb4b4f2c627cf6"
    end
    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.1.0/trackfetch-linux-x86_64"
      sha256 "644f57b4f7f2f574144609d00a3376ff6ec6f37b2cd48d2b2548aa68103d36a3"
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
