{ pkgs ? import <nixpkgs> { } }:
let
  # customPkgs = import ../private-nix { }; # For local development
  customPkgs = import (fetchTarball
    "https://github.com/Gosha/private-nixpkgs/archive/b5ccf6eab6d42fc7b65f0d6e1699c39551aaded0.tar.gz")
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
