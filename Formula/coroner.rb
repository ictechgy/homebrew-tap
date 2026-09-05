class Coroner < Formula
  desc "Local post-mortem triage for iOS telemetry (.ips + MetricKit) with MCP tools for coding agents"
  homepage "https://github.com/ictechgy/coroner"
  url "https://github.com/ictechgy/coroner/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "efb80d765de9eaa639bc437165b194afe2a98d22d0c799abfd4b34da966dcf16"
  license "MIT"

  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/coroner"
  end

  test do
    assert_match "coroner #{version}", shell_output("#{bin}/coroner --version")
  end
end
