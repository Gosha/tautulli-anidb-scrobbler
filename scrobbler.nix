{ pkgs ? import <nixpkgs> { } }:
let
  # customPkgs = import ../private-nix { }; # For local development
  customPkgs = import (fetchTarball
    "https://github.com/Gosha/private-nixpkgs/archive/a4b31d0e45c7e7e2d8393d438122250cf0eaca62.tar.gz")
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
