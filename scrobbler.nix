{ pkgs ? import <nixpkgs> { } }:
let
  # customPkgs = import ../private-nix { }; # For local development
  customPkgs = import (fetchTarball
    "https://github.com/Gosha/private-nixpkgs/archive/3c6d393188002e8aff63328ec6c94ddd2ecbca49.tar.gz")
    { };
  pythonPackages = pkgs.python3Packages;
  pyanidb = customPkgs.pyanidb;
in pythonPackages.buildPythonApplication {
  pname = "scrobble-anidb";
  version = "0.0.1";

  propagatedBuildInputs = [ pythonPackages.requests pyanidb ];

  src = ./src;
}
