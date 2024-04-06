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

iosevka_version="v29.1.0"
nerd_fonts_version="v3.2.0"
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
    unzip date zip tar cp sed

ryan_mono_version=$(date +%Y.%m.%d)

echo "$(bold "ryan-mono $ryan_mono_version")"

echo -e "$(cyan "Iosevka")\t\t$iosevka_version"
echo -e "$(cyan "Nerd Fonts")\t$nerd_fonts_version"
echo -e "$(cyan "FontForge")\t$(fontforge -version 2> /dev/null | sed -n 's|fontforge ||p')"

cpus=1
cpus_source="unknown"
command -v nproc &> /dev/null && cpus="$(nproc)" && cpus_source="nproc"
command -v sysctl &> /dev/null && cpus="$(sysctl -n hw.physicalcpu)" && cpus_source="sysctl"

echo -e "$(cyan "Concurrency")\t$cpus $(dim "($cpus_source)")"
echo

# rm -rf dist
rm -rf work && mkdir -p work dist
pushd work # => work/

git clone --depth 1 --branch "$iosevka_version" https://github.com/be5invis/Iosevka.git _iosevka

pushd _iosevka # => work/_iosevka
for patch in ../../patches/*.patch; do
    patch_name="$(basename "$patch")"
    git apply "$patch"
    git add .
    git commit -m "apply patch $patch_name"
done

npm ci

popd # => work/

curl -fsSL -o FontPatcher.zip \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/$nerd_fonts_version/FontPatcher.zip"
unzip FontPatcher.zip -d _fontpatcher
rm FontPatcher.zip

for font_family in "${font_families[@]}"; do
    echo "$(green "$(bold "Building $font_family")")"

    pushd _iosevka # => work/_iosevka
    cp "../../$font_family.toml" "private-build-plans.toml"
    sed -i "s/%%version%%/$ryan_mono_version/g" "private-build-plans.toml"

    npm run build -- "ttf::$font_family"
    popd # => work/

    mkdir -p "$font_family"
    cp _iosevka/dist/"$font_family"/TTF/* "$font_family"

    mkdir -p "${font_family}NerdFont"
    find "$font_family" -name '*.ttf' -print0 | xargs -0 --max-args=1 --max-procs="$cpus" \
        fontforge -script _fontpatcher/font-patcher --quiet --complete --outputdir "${font_family}NerdFont"

    cp ../LICENSE "$font_family"
    cp ../LICENSE "${font_family}NerdFont"

    zip -r -9 ../dist/"$font_family.zip" "$font_family"/*
    tar --gzip -cvf ../dist/"$font_family.tar.gz" "$font_family"/*
    tar --xz -cvf ../dist/"$font_family.tar.xz" "$font_family"/*

    zip -r -9 ../dist/"${font_family}NerdFont.zip" "${font_family}NerdFont"/*
    tar --gzip -cvf ../dist/"${font_family}NerdFont.tar.gz" "${font_family}NerdFont"/*
    tar --xz -cvf ../dist/"${font_family}NerdFont.tar.xz" "${font_family}NerdFont"/*
done
