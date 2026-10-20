class PinentryOp < Formula
  desc "GnuPG pinentry bridge to the official 1Password CLI"
  homepage "https://github.com/codegeek/pinentry-op"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.1/pinentry-op-aarch64-apple-darwin.tar.xz"
      sha256 "f9bc64aee86d1f32a616f542554d9d8cc66f3771b2f3d097e31487365a88caf1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.1/pinentry-op-x86_64-apple-darwin.tar.xz"
      sha256 "9855eb01f01a09bacfda0b76737e77349e6a1eebb548d9cd3e43557c8b71960d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.1/pinentry-op-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b2346c9e8851bb2806ef4352eeaeffdf99d9fe061ae35f7046b503d6d2c451b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codegeek/pinentry-op/releases/download/v0.1.1/pinentry-op-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73c7291dca565541a7e0e2b8c8b3cf094943ea8eb95b8615372cb9caf4b3f8c5"
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
