class Relay < Formula
  desc "Local, evidence-first continuity for AI-assisted software work"
  homepage "https://github.com/ictechgy/relay-continuity"
  license "MIT"
  version "0.2.0-rc.11"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.11/relay-macos-arm64"
      sha256 "6a547d4234817998597cbbac690c70e14b159a1842485e07cbb5b2a965aaf1bf"
    else
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.11/relay-macos-x86_64"
      sha256 "f17164e7ab2cbdf1841f02105b7d5b4037b7fe99e488ac17a0a6f3001cfbf70b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.11/relay-linux-x86_64"
      sha256 "07f5d39cafd982b1eb68899cfd2d641e1901380418c969583eba2afc36d3c6c2"
    end
  end

  def install
    bin.install Dir["relay-*"][0] => "relay"
  end

  test do
    system bin/"relay", "help"
  end
end
