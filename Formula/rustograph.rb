# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.1/rustograph-0.4.1-darwin-arm64.tar.gz"
      sha256 "74ccc6e77fe2ceb9b35d65fd320a8c23e5c458a99a33c42b49c4b10fa542df96"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.1/rustograph-0.4.1-darwin-amd64.tar.gz"
      sha256 "39e97501a14c2bf9231fe35a11446b8b2e80325b6a7d1bc8a49c48684bf8f57a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.1/rustograph-0.4.1-linux-arm64.tar.gz"
      sha256 "4ae7abdaaa77f9f2e85a2f993896986afd49867710094b14eafb5936d6ff839b"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.4.1/rustograph-0.4.1-linux-amd64.tar.gz"
      sha256 "f2a28ccad072428362b101508b257ee84d155ac67b4a455f26cf453308105f33"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
