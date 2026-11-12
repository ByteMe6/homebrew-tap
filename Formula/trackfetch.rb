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

    depends_on "deno"
    depends_on "ffmpeg"
    depends_on "yt-dlp"
  end

  # Homebrew has no bottles of ffmpeg, yt-dlp and deno on every macOS version
  # (Intel macOS in particular), and building ffmpeg from source takes hours.
  # On macOS these are installed as the upstream prebuilt binaries instead, so
  # `brew install` downloads files and never compiles anything.
  on_macos do
    resource "yt-dlp" do
      url "https://github.com/yt-dlp/yt-dlp/releases/download/2026.10.26/yt-dlp_macos"
      sha256 "0f922c15ccc0b83eefa1c8bc9104e434318c4bf16e408e1ee93b7745a6efe0aa"
    end

    on_arm do
      resource "ffmpeg" do
        url "https://github.com/eugeneware/ffmpeg-static/releases/download/b6.1.1/ffmpeg-darwin-arm64.gz"
        sha256 "8923876afa8db5585022d7860ec7e589af192f441c56793971276d450ed3bbfa"
      end

      resource "deno" do
        url "https://github.com/denoland/deno/releases/download/v2.9.8/deno-aarch64-apple-darwin.zip"
        sha256 "9f0bf660393da2eaff044cdc7444cb08c73f235849b61d224d825a194ce7c98e"
      end
    end

    on_intel do
      resource "ffmpeg" do
        url "https://github.com/eugeneware/ffmpeg-static/releases/download/b6.1.1/ffmpeg-darwin-x64.gz"
        sha256 "929b375c1182d956c51f7ac25e0b2b0411fb01f6f407aa15c9758efeb4242106"
      end

      resource "deno" do
        url "https://github.com/denoland/deno/releases/download/v2.9.8/deno-x86_64-apple-darwin.zip"
        sha256 "4b2f5edd2639b7470f034238b321d7002d8dfb4726d8558f52c17afac370eb2c"
      end
    end
  end

  def install
    libexec.install Dir["trackfetch-*"].first => "trackfetch"

    if OS.mac?
      resource("yt-dlp").stage do
        libexec.install "yt-dlp_macos" => "yt-dlp"
      end

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

      resource("deno").stage do
        libexec.install "deno"
      end

      # Apple Silicon only runs signed code, and the upstream builds are not signed.
      if Hardware::CPU.arm?
        [libexec/"trackfetch", libexec/"yt-dlp", libexec/"deno", libexec/"ffmpeg"].each do |binary|
          system "codesign", "--force", "--sign", "-", binary
        end
      end
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
      On macOS, ffmpeg, yt-dlp and deno are installed inside the formula and are
      not linked into your PATH; trackfetch uses them automatically. They are
      updated together with trackfetch:
        brew upgrade trackfetch
    EOS
  end

  test do
    assert_match "usage: trackfetch", shell_output("#{bin}/trackfetch --help")

    if OS.mac?
      assert_match "ffmpeg version", shell_output("#{libexec}/ffmpeg -version")
      assert_match "deno", shell_output("#{libexec}/deno --version")
      assert_match "yt-dlp", shell_output("#{libexec}/yt-dlp --version")
    end
  end
end
