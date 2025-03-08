{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildNpmPackage,
  ttfautohint-nox,
  cctools,

  pname,
  buildPlan,
}:
let
  manifest = import ../_manifest.nix;
in
buildNpmPackage {
  inherit pname;
  inherit (manifest) version;

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${manifest.iosevka.version}";
    inherit (manifest.iosevka) hash;
  };

  inherit (manifest.iosevka) npmDepsHash;

  patches = [
    ../patches/0001-calver.patch
  ];

  nativeBuildInputs =
    [
      ttfautohint-nox
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
      cctools
    ];

  configurePhase = ''
    runHook preConfigure

    cp ${../private-build-plans.toml} private-build-plans.toml
    substituteInPlace private-build-plans.toml --subst-var version

    runHook postConfigure
  '';

  buildPhase = ''
    export HOME="$TMPDIR"

    runHook preBuild
    npm run build --no-update-notifier -- --targets="ttf::${buildPlan}" --jCmd="$NIX_BUILD_CORES" --verbosity=9 | cat
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d "$out/share/fonts/truetype"
    install "dist/${buildPlan}/TTF"/* "$out/share/fonts/truetype"
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/ryanccn/ryan-mono";
    description = "Ryan's homemade Iosevka build";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ryanccn ];
  };
}
