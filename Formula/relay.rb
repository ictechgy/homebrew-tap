class Relay < Formula
  desc "Local, evidence-first continuity for AI-assisted software work"
  homepage "https://github.com/ictechgy/relay-continuity"
  license "MIT"
  version "0.2.0-rc.10"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.10/relay-macos-arm64"
      sha256 "54746aae852399c4e9f6ab5631ec4759d64c82fbb2f7f66cc80b079ded41fb33"
    else
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.10/relay-macos-x86_64"
      sha256 "f300a32a170f6d4ff22f0d333b0cdba56f32708a44a6183e7725b6f0a950d45f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.10/relay-linux-x86_64"
      sha256 "0c4dbb87b634f487d93cecc7acb930ca7ab26ec7d05072f118eb5115bdd03e41"
    end
  end

  def install
    bin.install Dir["relay-*"][0] => "relay"
  end

  test do
    system bin/"relay", "help"
  end
end
