class Relay < Formula
  desc "Local, evidence-first continuity for AI-assisted software work"
  homepage "https://github.com/ictechgy/relay-continuity"
  license "MIT"
  version "0.2.0-rc.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.7/relay-macos-arm64"
      sha256 "cdd7494438ba1a01acc8309c34d3b86f96e63b9b1ca9c16c1878467aae048ab1"
    else
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.7/relay-macos-x86_64"
      sha256 "ced7650138496627eeabb904ff59f3b7289c0cca91dbf2e1052e947db07f5bed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.7/relay-linux-x86_64"
      sha256 "13e3289556e2357b5f3cfc7eba3fe5729b473d111f51a7164800e137fafedeaf"
    end
  end

  def install
    bin.install Dir["relay-*"][0] => "relay"
  end

  test do
    system bin/"relay", "help"
  end
end
