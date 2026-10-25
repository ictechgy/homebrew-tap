# Homebrew formula — rustograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/rustograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Rustograph < Formula
  desc "Queryable dependency graph for Rust codebases, built on cargo metadata + syn"
  homepage "https://github.com/ictechgy/rustograph"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.6.0/rustograph-0.6.0-darwin-arm64.tar.gz"
      sha256 "acacf896196143c4f6e8f9370524d8ba2cef2b0944f3696869f801e8b954fddd"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.6.0/rustograph-0.6.0-darwin-amd64.tar.gz"
      sha256 "d9de89b29f3215d422824fdb53111ba3836939b9dea8e2421f4085c02ab02de5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/rustograph/releases/download/v0.6.0/rustograph-0.6.0-linux-arm64.tar.gz"
      sha256 "80320c08ddd8e0276f31b15c275ca63915a34741c4b07aba4a36264b9bf5713e"
    else
      url "https://github.com/ictechgy/rustograph/releases/download/v0.6.0/rustograph-0.6.0-linux-amd64.tar.gz"
      sha256 "e077fc3bcc3269b5f39c81b5c80d80fd219a00bf8cb12ec57148fb3b94a99d38"
    end
  end

  def install
    bin.install "rustograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustograph version")
  end
end
