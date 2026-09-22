# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.1.0/gartograph-0.1.0-darwin-arm64.tar.gz"
      sha256 "dd36ede13aa722ea31a542dc87506c006b1512eaf31894c25f3d9c831dfba467"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.1.0/gartograph-0.1.0-darwin-amd64.tar.gz"
      sha256 "7562804439ffe3569866ef4133e4904fb0a4398abc591f943511d401ecbc0837"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.1.0/gartograph-0.1.0-linux-arm64.tar.gz"
      sha256 "b59976ecf424a99e96508596dca713556ad027911730c0db3a838953f64db863"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.1.0/gartograph-0.1.0-linux-amd64.tar.gz"
      sha256 "3e63d34aa87401d766738514942c8d08f244c7c73af16fc364711167b2618b36"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
