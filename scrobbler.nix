{ pkgs ? import <nixpkgs> { } }:
let
  # customPkgs = import ../private-nix { }; # For local development
  customPkgs = import (fetchTarball
    "https://github.com/Gosha/private-nixpkgs/archive/5f50e5bc139d6c44e9c9c9012c5e2f8ac3863e5b.tar.gz")
    { };
  pythonPackages = pkgs.python3Packages;
  pyanidb = customPkgs.pyanidb;
in pythonPackages.buildPythonApplication {
  pname = "scrobble-anidb";
  version = "0.0.1";

  propagatedBuildInputs = [ pythonPackages.requests pyanidb ];

  makeWrapperArgs = [ "--unset PYTHONPATH" ];

  src = ./src;
}
