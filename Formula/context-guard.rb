class ContextGuard < Formula
  include Language::Python::Shebang

  desc "Local-first context guardrails for AI coding agents"
  homepage "https://github.com/ictechgy/context-guard"
  url "https://github.com/ictechgy/context-guard/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "a4e937d512e846096b69d121ea01bdff3015de6121c971744e695c1250f184f3"
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
