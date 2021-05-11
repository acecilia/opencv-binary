#!/bin/zsh

set -euo pipefail

readonly BUILD_DIR="opencv_build"
readonly OUTPUT_DIR="${BUILD_DIR}/output"

clone() {
    readonly VERSION="${1}"
    git clone --branch "${VERSION}" --depth 1 https://github.com/opencv/opencv.git "${BUILD_DIR}/${VERSION}"
}

build_xcframework() {
    readonly VERSION="${1}"
    shift

    python3 "${BUILD_DIR}/${VERSION}/platforms/apple/build_xcframework.py" \
        --build_only_specified_archs \
        --iphoneos_archs arm64,armv7 \
        --iphonesimulator_archs arm64,x86_64 \
        --out "${OUTPUT_DIR}" \
        "$@"
}

build_3_4_6() {
    clone 3.4.6
    clone 4.5.2

    # Add xcframework support to opencv 3.4.6
    rm -rf "${BUILD_DIR}/3.4.6/platforms"
    cp -rf "${BUILD_DIR}/4.5.2/platforms" "${BUILD_DIR}/3.4.6/platforms"

    build_xcframework 3.4.6 --legacy_build
}

build_4_5_2() {
    clone 4.5.2
    build_xcframework 4.5.2
}

rm -rf "${BUILD_DIR}"
"$@"