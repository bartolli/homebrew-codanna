class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  version "0.9.10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-macos-arm64.tar.xz"
      sha256 "7d7593e5df702fcc2ddeaf224db4ff084302b4a3474fb997cbfdf6933a3a85fa"
    end
    on_intel do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-macos-x64.tar.xz"
      sha256 "e44d3053396aa9e2c194e12b80668355a5e914f3b206311683354a1d9e04e1f8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bartolli/codanna/releases/download/v#{version}/codanna-#{version}-linux-x64.tar.xz"
      sha256 "ff1d8a1fd8460b5871ed372005af7f0b29e533e532c9dc681999dd0d9fb95d57"
    end
  end

  def install
    bin.install "codanna"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
