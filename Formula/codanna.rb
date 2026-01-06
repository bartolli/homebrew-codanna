class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://codanna.dev"
  version "0.9.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-macos-arm64.tar.xz"
      sha256 "36d48c2c2182fde1d7824990de1cdadf2ca9c1fc8de1dc13faafdb9331553373"
    end
    on_intel do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-macos-x64.tar.xz"
      sha256 "aa5aeced84182a29fcff0356847c93b01a477a145626acbf9bab466b3f6596a4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-linux-x64.tar.xz"
      sha256 "cdc2a23edcf166355d8170931d6e3a26b6b832fda679afe205ba7e18e50844b1"
    end
  end

  def install
    bin.install "codanna"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codanna --version")
  end
end
