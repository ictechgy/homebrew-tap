# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.0/gartograph-0.9.0-darwin-arm64.tar.gz"
      sha256 "18948d786f5376bf607ab160780a9b3af015f46e33fd532fe7134bd37627de04"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.0/gartograph-0.9.0-darwin-amd64.tar.gz"
      sha256 "f1675751bc1d613e2fe4213438798ef86ce0c77954f55b087d353df3739084b5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.0/gartograph-0.9.0-linux-arm64.tar.gz"
      sha256 "009a3dd5620e289a9f0f71ddaf324983093af82ec7b6424b7a4e1c81fdd012ad"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.9.0/gartograph-0.9.0-linux-amd64.tar.gz"
      sha256 "9537969de853b7eaa21d5924ea6d90e3933f05b9bbb12df7e1809d979215f90a"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
