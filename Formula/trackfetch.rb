class Trackfetch < Formula
  desc "Turn a text file of songs into tagged MP3s with Spotify metadata"
  homepage "https://github.com/ByteMe6/trackfetch"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.6/trackfetch-macos-arm64"
      sha256 "f77e46657f3b432bae8adecadddc9d8ee25fb43797a1bfaea8a6f75ad219a6b8"
    end
    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.6/trackfetch-macos-x86_64"
      sha256 "611e4dcfe184f8738f34e37639a34ad164a078a7585feb2082b398873024d7e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.6/trackfetch-linux-arm64"
      sha256 "2bfe14ddfc1e11537bae35d56c388b64d0646f06db0251806777c14def21905b"
    end
    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.6/trackfetch-linux-x86_64"
      sha256 "bfd13336cb16ef22c5383e34e12a20cb3d05dffb95f2fafebcc61f78132a772d"
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
