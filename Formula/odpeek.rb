# Homebrew formula — odpeek
class Odpeek < Formula
  desc "Expose Open Design's local UI to phones via Tailscale or Cloudflare"
  homepage "https://github.com/ictechgy/odpeek"
  url "https://registry.npmjs.org/odpeek/-/odpeek-0.3.0.tgz"
  sha256 "d08decc2e3df8438dcc1665d94efa12d824b18eb2f9a4648fda04267756ba2f2"
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
