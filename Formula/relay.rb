class Relay < Formula
  desc "Local, evidence-first continuity for AI-assisted software work"
  homepage "https://github.com/ictechgy/relay-continuity"
  license "MIT"
  version "0.2.0-rc.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.6/relay-macos-arm64"
      sha256 "9c5c2a40d04b048dc0ba6b7196be5d2a2d89cdd2732e15b3a5481b311e618715"
    else
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.6/relay-macos-x86_64"
      sha256 "60bef1a7a4c09bf959b1c1337f784b96d411bfd257711d5c5c50ac29824787fc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.6/relay-linux-x86_64"
      sha256 "493c5c3d9d0e1095c6219bb9d046fd91542fcbc00098d0e5944a2d62187b379b"
    end
  end

  def install
    bin.install Dir["relay-*"][0] => "relay"
  end

  test do
    system bin/"relay", "help"
  end
end
