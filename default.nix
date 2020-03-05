{ nixpkgs ? <nixpkgs>
, createDesktop ? true
}:

let
  pkgs = import nixpkgs {};
  mkGargoyle = pkgs.callPackage (import ./gargoyle.nix) {
    inherit createDesktop;
  };
in {
  adventure = mkGargoyle {
    name = "adventure";
    longName = "Colossal Cave Adventure";
    storyfile = builtins.fetchurl http://mirror.ifarchive.org/if-archive/games/zcode/Advent.z5;
  };

  galatea = mkGargoyle {
    name = "galatea";
    longName = "Galatea";
    storyfile = builtins.fetchurl http://mirror.ifarchive.org/if-archive/games/zcode/Galatea.zblorb;
  };

  z905 = mkGargoyle {
    name = "z905";
    longName = "9:05";
    storyfile = builtins.fetchurl http://mirror.ifarchive.org/if-archive/games/zcode/905.z5;
  };
}
