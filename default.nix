{ nixpkgs ? <nixpkgs>
, createDesktop ? true
}:

let
  pkgs = import nixpkgs {};

  mkGargoyle = { name, longName, storyfile }:
    let
      desktopItem = pkgs.makeDesktopItem {
        name = name;
        exec = name;
        desktopName = name;
        genericName = longName;
      };
      drv = pkgs.stdenv.mkDerivation {
        inherit name;

        buildInputs = with pkgs; [ makeWrapper ];
        propagatedBuildInputs = with pkgs; [ gargoyle ];

        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p "$out/bin"
          makeWrapper "${pkgs.gargoyle}/bin/gargoyle" "$out/bin/${name}" --add-flags "${storyfile}"
        '' + pkgs.lib.optionalString createDesktop ''
          mkdir -p "$out/share/applications"
          cp ${desktopItem}/share/applications/* "$out/share/applications"
        '';
      };
    in drv // pkgs.lib.optionalAttrs createDesktop { inherit desktopItem; };

in {
  adventure = mkGargoyle {
    name = "adventure";
    longName = "Colossal Cave Adventure";
    storyfile = builtins.fetchurl http://mirror.ifarchive.org/if-archive/games/zcode/Advent.z5;
  };
}
