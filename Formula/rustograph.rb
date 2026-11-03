# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.7.0/rustograph-0.7.0-darwin-arm64.tar.gz"
      sha256 "72e931b181cc80a058828dd39f0584cae17a405c204cdfe6d4af90dd926ee398"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.7.0/rustograph-0.7.0-darwin-amd64.tar.gz"
      sha256 "0c73b01a8a5ba82a536c94df7c05a208cd626f0886f5cd4536b177df6e468bfb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.7.0/rustograph-0.7.0-linux-arm64.tar.gz"
      sha256 "b7875cbef0efb82b19d8e51fc5cc1532c519e2c4850350edf2c348540e4b0e3c"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.7.0/rustograph-0.7.0-linux-amd64.tar.gz"
      sha256 "e30097e34c4062c4da3ed0c626264ddcc34004c5f0420d45bda8ed826d008da9"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
