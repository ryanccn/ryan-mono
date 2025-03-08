{
  stdenvNoCC,
  zip,
  gnutar,
  gzip,
  xz,
  strip-nondeterminism,

  srcs,
}:
let
  manifest = import ../_manifest.nix;
in
stdenvNoCC.mkDerivation {
  pname = "ryan-mono-dist";
  inherit (manifest) version;

  inherit srcs;

  nativeBuildInputs = [
    zip
    gnutar
    gzip
    xz
    strip-nondeterminism
  ];

  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
      pname="$(stripHash "$_src" | awk -F '-[0-9]' '{print $1}')"

      mkdir "$pname"
      cp "$_src/share/fonts/truetype"/* "$pname"
      cp ${../LICENSE} "$pname/LICENSE"
    done

    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild

    zip_flags=(-r -X -9)
    tar_flags=(--sort=name --mtime='1970-01-01 00:00Z' --owner=0 --group=0 --numeric-owner --pax-option='exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime')
    gzip_flags=(--no-name -9)
    xz_flags=(-9)

    for src in $srcs; do
      pname="$(stripHash "$src" | awk -F '-[0-9]' '{print $1}')"

      zip "''${zip_flags[@]}" "$pname.zip" "$pname"
      strip-nondeterminism --type zip "$pname.zip"

      tar "''${tar_flags[@]}" -cvf "$pname.tar" "$pname"/*
      gzip -k "''${gzip_flags[@]}" "$pname.tar"
      xz -k "''${xz_flags[@]}" "$pname.tar"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    find . -maxdepth 1 \( -name '*.zip' -or -name '*.tar.gz' -or -name '*.tar.xz' \) -exec cp {} "$out" \;

    runHook postInstall
  '';

  dontFixup = true;
}
