with import (builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs.git";
  ref = "master";
  rev = "00fc3cbf8c21a4139245e1b9c6173ecf000b5c7f";
}) {};

mkShell {
  buildInputs = [
    anytype babashka nixfmt qmk ventoy-full via vial
  ];
}
