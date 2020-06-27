{ pkgs ? import <nixpkgs> { } }:
let
  buildImage = pkgs.dockerTools.buildImage;
  pullImage = pkgs.pullImage;
in buildImage {
  name = "tautulli-auto-stuff";
  tag = "latest";
  contents = [ pkgs.tautulli ];
  runAsRoot = ''
    mkdir -p /scripts
    ln -s ${
      pkgs.callPackage ./scrobbler.nix { }
      # Rename to .sh to force tautulli to evalute the wrapper correctly
    }/bin/anidb_scrobble.py /scripts/anidb_scrobble.sh  '';
  config = {
    Env = [
      "PATH=${
        builtins.concatStringsSep ":" [
          "${pkgs.curl}/bin"
          "${pkgs.bash}/bin"
          "${pkgs.coreutils}/bin"
          "${pkgs.gnugrep}/bin"
        ]
      }"
      "TAUTULLI_DOCKER=True"
      "LANG=C.UTF-8"
      "PYTHONIOENCODING=UTF-8"
    ];
    Cmd = [ "${pkgs.tautulli}/bin/tautulli" "--datadir" "/config" ];
    ExposedPortsiy = { "3000/tcp" = { }; };
    Healthcheck = {
      # https://github.com/Tautulli/Tautulli/blob/7f178e091349a1399395c1ac3227d6f0fa801efc/Dockerfile#L23
      Test = [
        "CMD-SHELL"
        "curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1"
      ];
      StartPeriod = 90000000000;
    };
  };
}
