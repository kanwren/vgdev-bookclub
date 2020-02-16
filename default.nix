let
  pkgs = import <nixpkgs> {};

  mkGargoyle = { name, storyfile }: pkgs.stdenv.mkDerivation {
    inherit name;

    buildInputs = with pkgs; [ makeWrapper ];
    propagatedBuildInputs = with pkgs; [ gargoyle ];

    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p "$out/bin"
      makeWrapper "${pkgs.gargoyle}/bin/gargoyle" "$out/bin/${name}" --add-flags "${storyfile}"
    '';
  };

in {
  adventure = mkGargoyle {
    name = "adventure";
    storyfile = builtins.fetchurl http://mirror.ifarchive.org/if-archive/games/zcode/Advent.z5;
  };
}
