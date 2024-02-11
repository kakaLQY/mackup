with import (builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs.git";
  ref = "master";
  rev = "6e62521155cd3b4cdf6b49ecacf63db2a0cacc73";
}) {};

mkShell {
  buildInputs = [
    babashka nixfmt qmk ventoy-full via vial
  ];
}
