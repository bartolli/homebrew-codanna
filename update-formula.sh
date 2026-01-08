#!/bin/sh
set -eu

# Updates codanna.rb from dist-manifest.json
# Usage: ./update-formula.sh [version]
# If version not provided, fetches latest from GitHub API

REPO="bartolli/codanna"
FORMULA="Formula/codanna.rb"

if [ -n "${1:-}" ]; then
    version="$1"
else
    version=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
fi

version="${version#v}"  # strip v prefix
manifest_url="https://github.com/$REPO/releases/download/v${version}/dist-manifest.json"

echo "Fetching manifest for v${version}..."
manifest=$(curl -sLf "$manifest_url") || { echo "Failed to fetch manifest"; exit 1; }

# Extract SHA256 values
linux_x64=$(echo "$manifest" | grep -A1 '"linux-x64"' | grep sha256 | cut -d'"' -f4)
macos_arm64=$(echo "$manifest" | grep -A1 '"macos-arm64"' | grep sha256 | cut -d'"' -f4)
macos_x64=$(echo "$manifest" | grep -A1 '"macos-x64"' | grep sha256 | cut -d'"' -f4)

# Alternative: use jq if available
if command -v jq >/dev/null 2>&1; then
    linux_x64=$(echo "$manifest" | jq -r '.artifacts[] | select(.platform=="linux-x64") | .sha256')
    macos_arm64=$(echo "$manifest" | jq -r '.artifacts[] | select(.platform=="macos-arm64") | .sha256')
    macos_x64=$(echo "$manifest" | jq -r '.artifacts[] | select(.platform=="macos-x64") | .sha256')
fi

echo "linux-x64:    $linux_x64"
echo "macos-arm64:  $macos_arm64"
echo "macos-x64:    $macos_x64"

# Generate formula
cat > "$FORMULA" << EOF
class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/${REPO}"
  version "${version}"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/${REPO}/releases/download/v#{version}/codanna-#{version}-macos-arm64.tar.xz"
      sha256 "${macos_arm64}"
    end
    on_intel do
      url "https://github.com/${REPO}/releases/download/v#{version}/codanna-#{version}-macos-x64.tar.xz"
      sha256 "${macos_x64}"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/${REPO}/releases/download/v#{version}/codanna-#{version}-linux-x64.tar.xz"
      sha256 "${linux_x64}"
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
EOF

echo "Updated $FORMULA to v${version}"
