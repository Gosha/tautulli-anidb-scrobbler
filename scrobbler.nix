{ pkgs ? import <nixpkgs> { } }:
let
  # customPkgs = import ../private-nix { }; # For local development
  customPkgs = import (fetchTarball
    "https://github.com/Gosha/private-nixpkgs/archive/0f6f8ce11f73e79a650c7c4b3ae3c388b3dd2c02.tar.gz")
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
