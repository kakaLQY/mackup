{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "babashka";
  version = "0.4.6";

  src = fetchurl {
    url = "https://github.com/${name}/${name}/releases/download/v${version}/${name}-${version}-linux-amd64-static.tar.gz";
    sha256 = "0nmj5yvj8c9s2a27yhwhl1fqk6b3q8x2ilj2c36fni8r8idbxhda";
  };

  setSourceRoot = "sourceRoot=`pwd`";
  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D bb $out/bin
  '';
}
