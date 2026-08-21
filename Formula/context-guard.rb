class ContextGuard < Formula
  include Language::Python::Shebang

  desc "Local-first context guardrails for AI coding agents"
  homepage "https://github.com/ictechgy/context-guard"
  url "https://github.com/ictechgy/context-guard/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "81a1617ef30cf613f159a52a30a40f9dd6b8be84612f1c87c1c2d15ccb320151"
  license "Apache-2.0"

  depends_on "python@3.12"

  def install
    libexec.install "CHANGELOG.md", "LICENSE", "NOTICE", "README.md", "README.ko.md"
    libexec.install "context-guard-kit"
    libexec.install "plugins"

    python_shebang = detected_python_shebang
    Dir[libexec/"plugins/context-guard/bin/*"].each do |path|
      command = Pathname(path)
      next unless command.file?

      first_line = command.open { |file| file.gets.to_s }
      rewrite_shebang python_shebang, command if first_line.include?("python")
      bin.write_exec_script command
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/context-guard --version")
    mkdir testpath/"project"
    system bin/"context-guard", "setup", "--root", testpath/"project",
           "--agent", "codex", "--scope", "project", "--plan"
  end
end
