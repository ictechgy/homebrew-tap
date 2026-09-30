# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.0/rustograph-0.4.0-darwin-arm64.tar.gz"
      sha256 "730967242b07d0c7f17e07d724354f128efda385eb7b8823d807f27013c6dd09"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.0/rustograph-0.4.0-darwin-amd64.tar.gz"
      sha256 "24089a3799e76d5dc87970a12527a0924f59564a08ee5f296a0d9fee3ac9389a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.0/rustograph-0.4.0-linux-arm64.tar.gz"
      sha256 "6d992dd735a80533da293900468408c99051212871644eea216d29842a3b474a"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.0/rustograph-0.4.0-linux-amd64.tar.gz"
      sha256 "f40d76445a5771353c4e64dc586aca34e15e687cf66996d6ff15794e5d2604b0"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
