class Trackfetch < Formula
  desc "Turn a text file of songs into tagged MP3s with Spotify metadata"
  homepage "https://github.com/ByteMe6/trackfetch"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.10/trackfetch-macos-arm64"
      sha256 "5458da80ab889b97dd4b126405afa5534234f8898e69de9c852a49a49b0137d4"
    end

    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.10/trackfetch-macos-x86_64"
      sha256 "0b1d72cfd294a2124e5a5d9d537291a55430e425a11ef690115d0e357d810618"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.10/trackfetch-linux-arm64"
      sha256 "c94182f86cef527fefa0dc86a9ae90684fc6d16acb0456e456fda4c365bc24ef"
    end

    on_intel do
      url "https://github.com/ByteMe6/trackfetch/releases/download/v2.2.10/trackfetch-linux-x86_64"
      sha256 "9f8eca80a855b13facc4b22f89cb9a11b4282352e3759e2d57c033cb72e4d531"
    end

    depends_on "ffmpeg"
  end

  depends_on "deno"
  depends_on "pillow"
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
