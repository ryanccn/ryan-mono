{
  lib,
  stdenvNoCC,
  fetchzip,
  fontforge,

  pname,
  familyName,
  src,
}:
let
  manifest = import ../_manifest.nix;
in
stdenvNoCC.mkDerivation rec {
  inherit pname;
  inherit (manifest) version;
  inherit src;

  nerdFontsPatcher = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${manifest.nerd-fonts.version}/FontPatcher.zip";
    inherit (manifest.nerd-fonts) hash;
    stripRoot = false;
  };

  nativeBuildInputs = [ fontforge ];

  buildPhase = ''
    export HOME="$TMPDIR"
    runHook preBuild

    mkdir -p dist
    find . -name '*.ttf' -print0 | xargs -0 --max-args=1 --max-procs="$NIX_BUILD_CORES" \
        fontforge -script ${nerdFontsPatcher}/font-patcher --name '${familyName}' --quiet --complete --outputdir dist

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d "$out/share/fonts/truetype"
    install dist/* "$out/share/fonts/truetype"
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ryanccn/ryan-mono";
    description = "Ryan's homemade Iosevka build, with Nerd Font symbols";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ryanccn ];
  };
}
