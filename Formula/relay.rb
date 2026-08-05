class Relay < Formula
  desc "Local, evidence-first continuity for AI-assisted software work"
  homepage "https://github.com/ictechgy/relay-continuity"
  license "MIT"
  version "0.2.0-rc.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.8/relay-macos-arm64"
      sha256 "00c6314e209746c06b569efc1cea4657cec8ec8467aa1956aa04ce3c48fe84ca"
    else
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.8/relay-macos-x86_64"
      sha256 "62c462eab363681b03f82029a5689350ee9b77eb90e371479bab38d3c3ac84fb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/ictechgy/relay-continuity/releases/download/v0.2.0-rc.8/relay-linux-x86_64"
      sha256 "6fa5911a80f10f3523d82d74e9cb178a06e65887e7a71508f2afc36d3a91e9f0"
    end
  end

  def install
    bin.install Dir["relay-*"][0] => "relay"
  end

  test do
    system bin/"relay", "help"
  end
end
