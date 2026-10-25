# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.10.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.10.0/gartograph-0.10.0-darwin-arm64.tar.gz"
      sha256 "3764213d15500a35c68979f1df2ff24357d0eb492804a1903656714b54521f58"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.10.0/gartograph-0.10.0-darwin-amd64.tar.gz"
      sha256 "f0ff19269a42973af48e35b17a6783c5455d824c984737aff6804089920d16f4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.10.0/gartograph-0.10.0-linux-arm64.tar.gz"
      sha256 "934ca14b7a7b211f941f552ed001fe214643099d740822286f9d03c632e7a1e0"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.10.0/gartograph-0.10.0-linux-amd64.tar.gz"
      sha256 "d8d077aabee7896205255f55051adeeac3976f00b934645707d5a81cb2b7af67"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
