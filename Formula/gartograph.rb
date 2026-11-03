# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.11.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.11.0/gartograph-0.11.0-darwin-arm64.tar.gz"
      sha256 "0f37c3ed732b7b7846baafdb7c48ca820b8901f6820d36a72bfb54658fdd7d97"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.11.0/gartograph-0.11.0-darwin-amd64.tar.gz"
      sha256 "a4007f6630ffae5ce6d4b76ccdef78a2a06c65aead133371824860d8df2a8e23"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.11.0/gartograph-0.11.0-linux-arm64.tar.gz"
      sha256 "c7424e47f5970d4bee9d6ca527500adf36a4ab08f860dd05d35da4d993a43271"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.11.0/gartograph-0.11.0-linux-amd64.tar.gz"
      sha256 "dde79127efd4f81de055f9e9e97c3e08118abb838897b974a37c7ea79a3052f0"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
