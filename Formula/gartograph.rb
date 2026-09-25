# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.8.0/gartograph-0.8.0-darwin-arm64.tar.gz"
      sha256 "6d8e2667491b8731572db120eb233535748c2553348a6596b08d9265b206ca74"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.8.0/gartograph-0.8.0-darwin-amd64.tar.gz"
      sha256 "9559c038e7b24f460d5fa5c41079b89dd2452eae2c18e2be994d24a49aa6b809"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.8.0/gartograph-0.8.0-linux-arm64.tar.gz"
      sha256 "6aa9f2778e86d9e6214d9a5f9b865eaba8bf54e4320f0bcb49a4641373bc9e95"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.8.0/gartograph-0.8.0-linux-amd64.tar.gz"
      sha256 "8a637a4eb6de09d580eb794913978254c94e3d176b86eb6e175ef153afdeb4f1"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
