#!/bin/zsh

readonly BUILD_DIR="opencv_build"
readonly OPENCV_452_DIR="${BUILD_DIR}/4.5.2"
readonly OPENCV_346_DIR="${BUILD_DIR}/3.4.6"
readonly OUTPUT_DIR="${BUILD_DIR}/output"

rm -rf "${BUILD_DIR}"

git clone --branch 4.5.2 --depth 1 https://github.com/opencv/opencv.git "${OPENCV_452_DIR}"
git clone --branch 3.4.6 --depth 1 https://github.com/opencv/opencv.git "${OPENCV_346_DIR}"

# Add xcframework support to opencv 3.4.6
rm -rf "${OPENCV_346_DIR}/platforms"
cp -rf "${OPENCV_452_DIR}/platforms" "${OPENCV_346_DIR}/platforms"

python3 "${OPENCV_346_DIR}/platforms/apple/build_xcframework.py" \
    --build_only_specified_archs \
    --iphoneos_archs arm64,armv7 \
    --iphonesimulator_archs arm64,x86_64 \
    --legacy_build \
    --out "${OUTPUT_DIR}"

