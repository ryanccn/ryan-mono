#!/bin/bash
# shellcheck disable=SC2005,SC2120
set -eo pipefail

pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd "$@" > /dev/null
}

bold() {
    printf '\033[1m%s\033[22m' "$@"
}

dim() {
    printf '\033[2m%s\033[22m' "$@"
}

red() {
    printf '\033[31m%s\033[39m' "$@"
}

green() {
    printf '\033[32m%s\033[39m' "$@"
}

cyan() {
    printf '\033[36m%s\033[39m' "$@"
}

iosevka_version="v29.0.1"
nerd_fonts_version="v3.1.1"
font_families=("RyanMono" "RyanTerm")

check_dependencies() {
    for dep in "$@"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "$(red "Error: $(bold "$dep") is required for building ryan-mono!")"
            exit 1
        fi
    done
}

check_dependencies \
    printf echo rm mkdir git \
    node npm find xargs curl \
    unzip date zip tar cp

echo "$(bold "ryan-mono $(date +%Y.%m.%d)")"

echo -e "$(cyan "Iosevka")\t\t$iosevka_version"
echo -e "$(cyan "Nerd Fonts")\t$nerd_fonts_version"
echo -e "$(cyan "FontForge")\t$(fontforge -version 2> /dev/null | sed -n 's|fontforge ||p')"

cpus=1
cpus_source="unknown"
command -v nproc &> /dev/null && cpus="$(nproc)" && cpus_source="nproc"
command -v sysctl &> /dev/null && cpus="$(sysctl -n hw.physicalcpu)" && cpus_source="sysctl"

echo -e "$(cyan "Concurrency")\t$cpus $(dim "($cpus_source)")"
echo

rm -rf dist

for font_family in "${font_families[@]}"; do
    echo "$(green "$(bold "Building $font_family")")"

    rm -rf work && mkdir -p work
    pushd work

    git clone --depth 1 --branch "$iosevka_version" https://github.com/be5invis/Iosevka.git _iosevka
    cp "../$font_family.toml" _iosevka/private-build-plans.toml

    pushd _iosevka
    npm ci
    npm run build -- "ttf::$font_family"
    popd

    mkdir -p "$font_family"
    cp _iosevka/dist/"$font_family"/TTF/* "$font_family"

    curl -fsSL -o FontPatcher.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/$nerd_fonts_version/FontPatcher.zip"
    unzip FontPatcher.zip -d _fontpatcher
    rm FontPatcher.zip

    mkdir -p "${font_family}NerdFont"
    find "$font_family" -name '*.ttf' -print0 | xargs -0 --max-args=1 --max-procs="$cpus" \
        fontforge -script _fontpatcher/font-patcher --quiet --complete --outputdir "${font_family}NerdFont"

    popd
    mkdir -p dist

    pushd work

    zip -r -9 ../dist/"$font_family.zip" "$font_family"/*
    tar --gzip -cvf ../dist/"$font_family.tar.gz" "$font_family"/*
    tar --xz -cvf ../dist/"$font_family.tar.xz" "$font_family"/*

    zip -r -9 ../dist/"${font_family}NerdFont.zip" "${font_family}NerdFont"/*
    tar --gzip -cvf ../dist/"${font_family}NerdFont.tar.gz" "${font_family}NerdFont"/*
    tar --xz -cvf ../dist/"${font_family}NerdFont.tar.xz" "${font_family}NerdFont"/*

    popd

    rm -rf work
done
