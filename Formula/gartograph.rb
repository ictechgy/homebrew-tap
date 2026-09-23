# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.3.0/gartograph-0.3.0-darwin-arm64.tar.gz"
      sha256 "00a427f7fd5165380687ef5d18569abb819912fe82eb3e7973af4d90d64eede2"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.3.0/gartograph-0.3.0-darwin-amd64.tar.gz"
      sha256 "30b4af9964a157dbcab7bfd7053193db937a48c34c06c0a96530b655fb1e23d9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.3.0/gartograph-0.3.0-linux-arm64.tar.gz"
      sha256 "27a574dc1492d7398124c20e1caada62e3128eacf13d99256d2ff11d67d0038b"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.3.0/gartograph-0.3.0-linux-amd64.tar.gz"
      sha256 "2e3428fe1fba1c6091eaf1698bd85421e74464cb21f214c41555901884c99e1a"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
