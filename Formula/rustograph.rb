# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.1.0/rustograph-0.1.0-darwin-arm64.tar.gz"
      sha256 "27cc055c67306863efb8ed53edb949edb2a8e5abbc9a1e363025e875632a01d6"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.1.0/rustograph-0.1.0-darwin-amd64.tar.gz"
      sha256 "a1c343ed72c1a8f903df710a069b467f7b04c0eaeb81e8537e088b54a2eb5cf7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.1.0/rustograph-0.1.0-linux-arm64.tar.gz"
      sha256 "05f35c343c8e5e580ebab2d389fe8e0731b815f4d29c28376150d5dea922f5b2"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.1.0/rustograph-0.1.0-linux-amd64.tar.gz"
      sha256 "d137ec6d2361fbf47d35e27b852a2b9b736202db59104b6390e19fd6441ea392"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
