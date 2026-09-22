# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.2.0/gartograph-0.2.0-darwin-arm64.tar.gz"
      sha256 "a76a509cc4e7ef2be4ab573b8d115a476edfbdd713412ea752be38fbe412d207"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.2.0/gartograph-0.2.0-darwin-amd64.tar.gz"
      sha256 "33728acfe3cba7d2174e9446713bb3001e9ac4fb96d31b8e85c48f5c93e3bf58"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.2.0/gartograph-0.2.0-linux-arm64.tar.gz"
      sha256 "64963818e94492c26b1e0c076f92bd24497af18993b85124b64e1f4942b0fa14"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.2.0/gartograph-0.2.0-linux-amd64.tar.gz"
      sha256 "82ea1e351600846d12746f2f45161f4c39801725c18ffcf5238eca05b156074b"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
