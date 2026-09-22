# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.0/rustograph-0.2.0-darwin-arm64.tar.gz"
      sha256 "0679c337154620c5c735c1af8042ab287f32cc1b51977176cf24892f3b60f17e"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.0/rustograph-0.2.0-darwin-amd64.tar.gz"
      sha256 "bd60792368697cee1600b89986f7de45d15c72ef9a4d3286e14a752ebeb984d6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.0/rustograph-0.2.0-linux-arm64.tar.gz"
      sha256 "604827dfb14cbb1a725363ca00aa184d36bc7b06f6e3899fe96f76c9a634fdfa"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.2.0/rustograph-0.2.0-linux-amd64.tar.gz"
      sha256 "70cf36a427ad2c82cd3527abf5d01129fac6409f39c650d533d683ad682c4d7b"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
