{
  lib,
  appimageTools,
  fetchurl,
}:

let
  # Written by .github/workflows/nix-track.yml when upstream publishes a release.
  release = lib.importJSON ./release.json;
  pname = "bilisail";
  inherit (release) version;

  src = fetchurl {
    url = "https://github.com/CKopoer/BiliSail/releases/download/${lib.escapeURL "v${version}"}/${lib.escapeURL "BiliSail-${version}-linux-x64.AppImage"}";
    inherit (release) hash;
  };

  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The bundled libgcrypt links libgpg-error without shipping it.
  extraPkgs = pkgs: [ pkgs.libgpg-error ];

  extraInstallCommands = ''
    install -Dm644 ${contents}/dev.bilisail.bilisail.desktop $out/share/applications/dev.bilisail.bilisail.desktop
    install -Dm644 ${contents}/dev.bilisail.bilisail.png $out/share/pixmaps/dev.bilisail.bilisail.png
  '';

  meta = {
    description = "Cross-platform third-party Bilibili client focused on viewing";
    homepage = "https://github.com/CKopoer/BiliSail";
    # Upstream has not chosen a license yet.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "bilisail";
    platforms = [ "x86_64-linux" ];
  };
}
