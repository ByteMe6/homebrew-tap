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

    depends_on "ffmpeg"
  end

  depends_on "deno"
  depends_on "yt-dlp"

  # ffmpeg is the formula Homebrew most often has to build from source, and a
  # source build takes hours. On macOS the upstream static binary is installed
  # inside the formula instead, so `brew install` never compiles it.
  on_macos do
    on_arm do
      resource "ffmpeg" do
        url "https://github.com/eugeneware/ffmpeg-static/releases/download/b6.1.1/ffmpeg-darwin-arm64.gz"
        sha256 "8923876afa8db5585022d7860ec7e589af192f441c56793971276d450ed3bbfa"
      end
    end

    on_intel do
      resource "ffmpeg" do
        url "https://github.com/eugeneware/ffmpeg-static/releases/download/b6.1.1/ffmpeg-darwin-x64.gz"
        sha256 "929b375c1182d956c51f7ac25e0b2b0411fb01f6f407aa15c9758efeb4242106"
      end
    end
  end

  def install
    libexec.install Dir["trackfetch-*"].first => "trackfetch"

    binaries = [libexec/"trackfetch"]

    if OS.mac?
      resource("ffmpeg").stage do
        # Homebrew unpacks single-file .gz resources on some versions and
        # leaves them alone on others, so handle both.
        binary = Dir["ffmpeg-darwin-*"].first
        if binary.end_with?(".gz")
          system "gunzip", binary
          binary = binary.delete_suffix(".gz")
        end
        libexec.install binary => "ffmpeg"
      end

      binaries << libexec/"ffmpeg"
    end

    binaries.each do |binary|
      # Downloads do not keep the executable bit.
      binary.chmod 0755

      # Apple Silicon only runs signed code and the upstream builds are not signed.
      system "codesign", "--force", "--sign", "-", binary if OS.mac? && Hardware::CPU.arm?
    end

    # trackfetch runs yt-dlp, ffmpeg and deno from PATH. The wrapper puts the
    # bundled copies in front of it, so the formula works on a bare system.
    (bin/"trackfetch").write <<~SH
      #!/bin/sh
      PATH="#{libexec}:$PATH"
      export PATH
      exec "#{libexec}/trackfetch" "$@"
    SH
    chmod 0755, bin/"trackfetch"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      On macOS, ffmpeg is installed inside the formula and is not linked into
      your PATH; trackfetch uses it automatically. yt-dlp and deno come from
      Homebrew as usual.
    EOS
  end

  test do
    assert_match "usage: trackfetch", shell_output("#{bin}/trackfetch --help")

    if OS.mac?
      assert_match "ffmpeg version", shell_output("#{libexec}/ffmpeg -version")
    end

    assert_predicate Formula["yt-dlp"].opt_bin/"yt-dlp", :exist?
    assert_predicate Formula["deno"].opt_bin/"deno", :exist?
  end
end
