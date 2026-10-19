class PinentryOp < Formula
  desc "GnuPG pinentry bridge to the official 1Password CLI"
  homepage "https://github.com/codegeek/pinentry-op"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.0/pinentry-op-aarch64-apple-darwin.tar.xz"
      sha256 "873f59e5588212f4500b64f5bfea7234670067118df7da268d966ee69ba0327b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.0/pinentry-op-x86_64-apple-darwin.tar.xz"
      sha256 "b04734b4e5ad2d32a8892d541a42b4e86385db6f46229446ec2f866c35f1ecbc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.0/pinentry-op-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "74a182ac67d945ac21f9603855238c3c8a5425ad7469cb1738bb0f9a56dda920"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.0/pinentry-op-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f716719a183524b9a5f2dcc5f23c9ab40cad0bade4d7ae87d0f15e3fb75a1db"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "pinentry-op"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pinentry-op"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pinentry-op"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pinentry-op"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
