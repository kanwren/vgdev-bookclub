{ stdenv, lib
, makeDesktopItem, makeWrapper
, gargoyle
, createDesktop ? true
}:

{ name, longName, storyfile }:

let
  desktopItem = makeDesktopItem {
    name = name;
    exec = name;
    desktopName = name;
    genericName = longName;
  };
  drv = stdenv.mkDerivation {
    inherit name;

    buildInputs = [ makeWrapper ];
    propagatedBuildInputs = [ gargoyle ];

    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p "$out/bin"
      makeWrapper \
        "${gargoyle}/bin/gargoyle" \
        "$out/bin/${name}" \
        --add-flags "${storyfile}"
    '' + lib.optionalString createDesktop ''
      mkdir -p "$out/share/applications"
      cp ${desktopItem}/share/applications/* "$out/share/applications"
    '';
  };
in drv // lib.optionalAttrs createDesktop { inherit desktopItem; }

