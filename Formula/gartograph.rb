# Homebrew formula — gartograph
#
# 이 파일이 ictechgy/homebrew-tap 의 Formula/gartograph.rb 원본이다.
# 릴리스 워크플로우가 버전·태그·SHA 자리표시자(@…@)를 채워 탭에 복사한다.
# 탭을 직접 고치지 말고 여기서 고친 뒤 릴리스한다.
class Gartograph < Formula
  desc "Queryable dependency graph for Go codebases, built on go/packages"
  homepage "https://github.com/ictechgy/gartograph"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.5.0/gartograph-0.5.0-darwin-arm64.tar.gz"
      sha256 "f98a04a42ac1cde4e403c8463f3dbcac3d3589dea0252b71793d54a4da7040bb"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.5.0/gartograph-0.5.0-darwin-amd64.tar.gz"
      sha256 "49863da3092255be971eb0396f7f246a10851054b48fe3f8d47519255ca0cf56"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ictechgy/gartograph/releases/download/v0.5.0/gartograph-0.5.0-linux-arm64.tar.gz"
      sha256 "7527bce098ce50d88f990053800a7db6ee70e0ae4b0699d70e5af5383767fec2"
    else
      url "https://github.com/ictechgy/gartograph/releases/download/v0.5.0/gartograph-0.5.0-linux-amd64.tar.gz"
      sha256 "1f00eb9dcaab9d003dd83aa6da64496dd1a74b3895188c648f9868386f6a461e"
    end
  end

  def install
    bin.install "gartograph"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gartograph version")
  end
end
