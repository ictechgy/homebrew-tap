# Homebrew formula — odpeek
class Odpeek < Formula
  desc "Expose Open Design's local web UI to your phone via Tailscale or a Cloudflare tunnel"
  homepage "https://github.com/ictechgy/odpeek"
  url "https://registry.npmjs.org/odpeek/-/odpeek-0.2.0.tgz"
  sha256 "ad093b3bd26fb832d71a3c24cdca8be51acd4eee8fce702ff7aca34ecfcc6f4a"
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
