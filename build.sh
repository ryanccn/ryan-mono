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

iosevka_version="v28.1.0"
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

if command -v brotli &> /dev/null;
then echo -e "$(cyan "Brotli")\t\tavailable $(dim "($(command -v brotli))")"
else echo -e "$(cyan "Brotli")\t\tunavailable"
fi

cpus=1
cpus_source="unknown"
command -v nproc &> /dev/null && cpus="$(nproc)" && cpus_source="nproc"
command -v sysctl &> /dev/null && cpus="$(sysctl -n hw.physicalcpu)" && cpus_source="sysctl"

echo -e "$(cyan "Concurrency")\t$cpus $(dim "($cpus_source)")"
echo

rm -rf dist

for font_family in "${font_families[@]}"; do
    echo "$(green "$(bold "Building $font_family")")"

    rm -rf work
    mkdir -p work
    pushd work

    git clone --depth 1 --branch "$iosevka_version" https://github.com/be5invis/Iosevka.git iosevka
    cp "../$font_family.toml" iosevka/private-build-plans.toml

    pushd iosevka
    npm ci
    npm run build -- "ttf::$font_family"
    popd

    mkdir -p dist
    cp iosevka/dist/"$font_family"/TTF/* dist

    curl -fsSL -o FontPatcher.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/$nerd_fonts_version/FontPatcher.zip"
    unzip FontPatcher.zip -d FontPatcher

    mkdir -p dist-nerd
    find dist -name '*.ttf' -print0 | xargs -0 --max-args=1 --max-procs="$cpus" \
        fontforge -script FontPatcher/font-patcher --quiet --complete --outputdir dist-nerd

    popd
    mkdir -p dist

    pushd work/dist

    zip -r -9 ../../dist/"$font_family".zip ./*
    tar --gzip -cf ../../dist/"$font_family".tar.gz ./*
    tar --xz -cf ../../dist/"$font_family".tar.xz ./*
    command -v brotli &> /dev/null && \
        tar --use-compress-program "brotli -Z" -cf ../../dist/"$font_family".tar.br ./*

    popd

    pushd work/dist-nerd

    zip -r -9 ../../dist/"$font_family"NerdFont.zip ./*
    tar --gzip -cf ../../dist/"$font_family"NerdFont.tar.gz ./*
    tar --xz -cf ../../dist/"$font_family"NerdFont.tar.xz ./*
    command -v brotli &> /dev/null && \
        tar --use-compress-program "brotli -Z" -cf ../../dist/"$font_family"NerdFont.tar.br ./*

    popd

    rm -rf work
done
