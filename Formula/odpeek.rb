# Homebrew formula — odpeek
class Odpeek < Formula
  desc "Expose Open Design's local web UI to your phone via Tailscale or a Cloudflare tunnel"
  homepage "https://github.com/ictechgy/odpeek"
  url "https://registry.npmjs.org/odpeek/-/odpeek-0.1.1.tgz"
  sha256 "9e62d1bb244b7af41d176cc81938123245e8407b8604da0145e074e328008043"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Open Design", shell_output("#{bin}/odpeek --help")
  end
end
