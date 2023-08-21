{ stdenv
, lib
, meson
, ninja
, pkg-config
, makeWrapper
, gnome

# This is the prefix used for the installed files in the output.
, prefix ? "one.foodogsquared.MoseyBranch"
, serviceScript ? "Hyprland"

, agsScript ? "ags"
, polkitScript ? "polkit"
, ibusScript ? "ibus start"
}:

stdenv.mkDerivation rec {
  pname = "mosey-branch-custom-desktop-session";
  version = "2023-08-13";

  src = ./.;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  mesonFlags = [
    "-Dservice_script=${serviceScript}"
    "-Dags_script=${agsScript}"
    "-Dibus_script=${ibusScript}"
    "-Dpolkit_script=${polkitScript}"
  ];

  passthru.providedSessions = [ "mosey-branch" ];

  postInstall = ''
    wrapProgram "$out/bin/mosey-branch-session" \
      --prefix XDG_DATA_DIRS : "${placeholder "out"}/share" \
      --prefix PATH : "${lib.makeBinPath [ gnome.gnome-session ]}"
  '';

  meta = with lib; {
    description = "Custom desktop files for the custom desktop environment";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
