# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.7.0/gartograph-0.7.0-darwin-arm64.tar.gz"
      sha256 "7bd0b47d430f7f3daf3e3ec8264b451217856b61e08a8de3b025791949fc1c15"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.7.0/gartograph-0.7.0-darwin-amd64.tar.gz"
      sha256 "62e072d905828fbcb92680c68e961acd2c2a1845540e4f530dcc27c8e5234971"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.7.0/gartograph-0.7.0-linux-arm64.tar.gz"
      sha256 "1056d2fa58009884498767930fcfe9b7f2b74db41cb54e5102270dd3e5df2d68"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.7.0/gartograph-0.7.0-linux-amd64.tar.gz"
      sha256 "caf316404bbf7024f79f8b4afc7a59de2c7820791f0aece19dcc190fb63d5e0b"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
