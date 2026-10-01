# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.9.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.1/gartograph-0.9.1-darwin-arm64.tar.gz"
      sha256 "d2a42e81bc237c455540e52c94e2e1e38d23a8226c98eabf13766f9129233ac4"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.1/gartograph-0.9.1-darwin-amd64.tar.gz"
      sha256 "f02965954b816a08b41c02907c6c7ad8038c041fd077d634bc7a2759dd2d7836"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.1/gartograph-0.9.1-linux-arm64.tar.gz"
      sha256 "0f27c3fa9f1f7ae2a341d6b3e100e10fd20d6401baa0bb6517a894cb507c6b58"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.1/gartograph-0.9.1-linux-amd64.tar.gz"
      sha256 "80a079ef75650ee5e812854f428065dd6db745feffbcab8a1aa94a3cde51e9aa"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
