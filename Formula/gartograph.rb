# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.9.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.2/gartograph-0.9.2-darwin-arm64.tar.gz"
      sha256 "6d95ea8cc9fbf7709c23d566dd1f46c1b4d6f83621a371e380be931fcf09fb4e"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.2/gartograph-0.9.2-darwin-amd64.tar.gz"
      sha256 "942869fbd78772a382f7bd4c82d302ec198cbd33ff97a61b8fe4847642ded9ca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.2/gartograph-0.9.2-linux-arm64.tar.gz"
      sha256 "9e206e32a17343e510880e1788768515fef25efb8abbf7e8907f300aaca36618"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.2/gartograph-0.9.2-linux-amd64.tar.gz"
      sha256 "dd0fe731acfda21d16babe63565fc7c5cc058d6b183f61814a15bf4b2e8529a8"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
