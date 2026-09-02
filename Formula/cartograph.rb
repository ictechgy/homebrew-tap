class Cartograph < Formula
  desc "Queryable dependency graph for Swift and iOS codebases, built on IndexStoreDB"
  homepage "https://github.com/ictechgy/cartograph"
  url "https://github.com/ictechgy/cartograph/releases/download/0.2.0/cartograph-0.2.0-macos-universal.tar.gz"
  sha256 "2f8175a41706ebc374208e0c2e159e94ba295fcce48d6540614ecaefe655f96d"
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

      Then build once so the compiler writes an index store, and run a query.
      Cartograph finds the store on its own:

        swift build
        cartograph dead --strict

      For an Xcode project:

        xcodebuild build -scheme MyApp COMPILER_INDEX_STORE_ENABLE=YES \\
          -derivedDataPath DerivedData
        cartograph dead --index-store DerivedData/Index.noindex/DataStore
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
