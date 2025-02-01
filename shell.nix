with import (builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs.git";
  ref = "master";
  rev = "fd4ca2fcd587216ca1a023643c078f55cd32272f";
}) {};

mkShell {
  buildInputs = [
    anytype babashka qmk ventoy-full via vial
  ];
}
