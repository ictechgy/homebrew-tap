class Relay < Formula
  desc "Local, evidence-first continuity for AI-assisted software work"
  homepage "https://github.com/ictechgy/relay-continuity"
  license "MIT"
  version "0.2.0-rc.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.9/relay-macos-arm64"
      sha256 "0a6a3dc2cd1c2048fc92e966fd735e0f283d9f856b1a6aa129c9fc485664dcb1"
    else
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.9/relay-macos-x86_64"
      sha256 "95bf151da8d5149b5a05b9ac902d831052ecd2528c46a187d3243825f7cad9a2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.9/relay-linux-x86_64"
      sha256 "eb337d87a85984913ce88133afcaf77a061528b5db6bae6d811980a00b4a9b93"
    end
  end

  def install
    bin.install Dir["relay-*"][0] => "relay"
  end

  test do
    system bin/"relay", "help"
  end
end
