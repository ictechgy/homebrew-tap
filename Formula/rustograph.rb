# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.1/rustograph-0.2.1-darwin-arm64.tar.gz"
      sha256 "1af0343ff11a3fdfc86b122aea30d2895a49097900d2a4dbfdfacd90cbb0215f"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.1/rustograph-0.2.1-darwin-amd64.tar.gz"
      sha256 "c427c7b92f5045d24ce4b2d00b97f52543262b3ecca9b181bde338c95e0a2d9d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.1/rustograph-0.2.1-linux-arm64.tar.gz"
      sha256 "ebaa434bc21d82dff029647042b3b15a363e3e167c2b1b912d66a043c1eb92f1"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.1/rustograph-0.2.1-linux-amd64.tar.gz"
      sha256 "a2d9c81f6dae856e7a6f5ab814f272cd4cac76546b3406ffd5476868e5553907"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
