class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://codanna.dev"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-macos-arm64.tar.xz"
      sha256 "a366a808562961480945ebad38941ff4510be24f106c9f3f67a9f1eb7a5d7bf7"
    end
    on_intel do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-macos-x64.tar.xz"
      sha256 "06cd58417769969d1eedb2b2b6b7d18491dce90d2040cfeca9f93e3e9dca2530"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-linux-x64.tar.xz"
      sha256 "ff28ac89b4e0db0356fb96978ed725335e7ed78c3ce93767806f118464eeebf8"
    end
  end

  def install
    bin.install "codanna"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codanna --version")
  end
end
