# Homebrew formula — odpeek
class Odpeek < Formula
  desc "Expose Open Design's local web UI to your phone via Tailscale or a Cloudflare tunnel"
  homepage "https://github.com/ictechgy/odpeek"
  url "https://registry.npmjs.org/odpeek/-/odpeek-0.1.0.tgz"
  sha256 "2f6bc816eabb3b251dae319aee2be3892fdaee2a0824413a85d5b768ee63e90c"
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
