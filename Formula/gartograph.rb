# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.4.0/gartograph-0.4.0-darwin-arm64.tar.gz"
      sha256 "19669eda30dccf6e711980361da0faf3d00d33d1510cc002e0f5e1120e81e411"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.4.0/gartograph-0.4.0-darwin-amd64.tar.gz"
      sha256 "87ea76c4c563c713a447569dbe986ae89f7ba2b885db39b9604d60bd0992e38a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.4.0/gartograph-0.4.0-linux-arm64.tar.gz"
      sha256 "bd6c99be31d0c3a58a6c925f47814335a69f618aabbd20026a41e12893792beb"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.4.0/gartograph-0.4.0-linux-amd64.tar.gz"
      sha256 "0935a545ce1ffb974d9555be4c4bb943b699e70c4d574601c43638e1757ea588"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
