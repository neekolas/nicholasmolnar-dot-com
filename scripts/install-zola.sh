#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
version=0.23.6
if [ -x .bin/zola ] && [ "$(.bin/zola --version)" = "zola $version" ]; then exit 0; fi
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)
    target=aarch64-apple-darwin
    checksum=cbffbd29b3f59c3f52633507c8cb945a7a02d8b1399b43b235f5932912297aa3 ;;
  Linux-x86_64)
    target=x86_64-unknown-linux-gnu
    checksum=8f5132b3522412d04e395e0b25f6d68613ad272a873e54a2b3ebf664873024a4 ;;
  *) echo 'Install Zola 0.23.6 from getzola.org into .bin/zola on this platform.' >&2; exit 1 ;;
esac
archive=$(mktemp)
trap 'rm -f "$archive"' EXIT
curl -fsSL "https://github.com/getzola/zola/releases/download/v$version/zola-v$version-$target.tar.gz" -o "$archive"
printf '%s  %s\n' "$checksum" "$archive" | shasum -a 256 -c -
mkdir -p .bin
tar -xzf "$archive" -C .bin zola
.bin/zola --version
