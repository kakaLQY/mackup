with import (builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs.git";
  ref = "master";
  rev = "a5c77f8b933cd3e14f31ebec57ef080d894b6fac";
}) {};

mkShell {
  buildInputs = [
    babashka qmk via vial
  ];
}
