class Cartograph < Formula
  desc "Queryable dependency graph for Swift and iOS codebases, built on IndexStoreDB"
  homepage "https://github.com/ictechgy/cartograph"
  url "https://github.com/ictechgy/cartograph/releases/download/0.1.0/cartograph-0.1.0-macos-universal.tar.gz"
  sha256 "1c10285ec78fa31ecc6dd0b5063b34f83deb7399d93a14e842437a51bfe8a927"
  license "MIT"

  depends_on macos: :sonoma

  def install
    bin.install "cartograph"
  end

  def caveats
    <<~EOS
      Cartograph reads the index store your compiler produces, and loads libIndexStore
      from the active toolchain at run time. Install Xcode or the Command Line Tools:

        xcode-select --install

      Then point it at an index store, or let it find the one your build already wrote:

        swift build -Xswiftc -index-store-path -Xswiftc .index-store
        cartograph dead --index-store .index-store
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartograph --version")
    assert_match "cartograph", shell_output("#{bin}/cartograph --help")
    # An empty directory has no index store, so the tool must fail with status 2
    # (tool failure) rather than 0 or a usage error. shell_output asserts the status.
    assert_match "Could not find an index store",
                 shell_output("#{bin}/cartograph cycles --project #{testpath} 2>&1", 2)
  end
end
