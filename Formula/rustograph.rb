# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.3.0/rustograph-0.3.0-darwin-arm64.tar.gz"
      sha256 "85fce43724267938d3c0005eaeb0283d82fe266ffb2ee3c465769be818225a9e"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.3.0/rustograph-0.3.0-darwin-amd64.tar.gz"
      sha256 "f24d7f7f87497b8aaf839840f470cb0725043ba7ebee6b7c3387cd54be4d0d7f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.3.0/rustograph-0.3.0-linux-arm64.tar.gz"
      sha256 "e54457378f02c126ce9ed9cba50f1c39eb14919ddfb3a762f1b777d15ff6e59a"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.3.0/rustograph-0.3.0-linux-amd64.tar.gz"
      sha256 "c83d8aa66463742fb4f086aa367aa35955b9461cdce10720f153e26787cd9127"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
