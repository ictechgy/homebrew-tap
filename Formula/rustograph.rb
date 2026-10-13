# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.5.0/rustograph-0.5.0-darwin-arm64.tar.gz"
      sha256 "588fce21a0f6c406301e465892b74bbef3f1cee2a7ae506f82f229e8c3257b99"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.5.0/rustograph-0.5.0-darwin-amd64.tar.gz"
      sha256 "93985413457cc3ca39eedf5ae77f937a0157f1eed8d3b27105e8013a84adf537"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.5.0/rustograph-0.5.0-linux-arm64.tar.gz"
      sha256 "a2442ecae38854125d9b2b15a784c6e7edce71236894388c8f6c3e455c182d4b"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.5.0/rustograph-0.5.0-linux-amd64.tar.gz"
      sha256 "bf0d065899d91989ca9400629a42be45340ee240606464de7ed138b3ba5e1cdb"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
