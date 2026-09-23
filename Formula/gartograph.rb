# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.6.0/gartograph-0.6.0-darwin-arm64.tar.gz"
      sha256 "767c846bc314d6ec0f4a01253a65efd51547e158ed59a83680d429be3b3c5db9"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.6.0/gartograph-0.6.0-darwin-amd64.tar.gz"
      sha256 "4835e17061756f3347490987b0f6caf1bf32baf66edbd43dcf0307455f2b9536"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.6.0/gartograph-0.6.0-linux-arm64.tar.gz"
      sha256 "ce7bb02df5f579d2a49b5fc4a69c7937d7e8a63e5e6005a048737950131b18f3"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.6.0/gartograph-0.6.0-linux-amd64.tar.gz"
      sha256 "4f7a34ae3dbdc3c1afed500020871f00e5e12ea032a56218c57c39d8162eb42a"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
