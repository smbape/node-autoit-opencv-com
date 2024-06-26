#!/usr/bin/env bash

# ================================
# stash for release
# ================================
git stash push --include-untracked


# ================================
# tidy
# ================================
node ../${ESLINT_CONFIG_PROJECT}/node_modules/eslint/bin/eslint.js --config=../${ESLINT_CONFIG_PROJECT}/.eslintrc --fix 'src/**/*.js' 'scripts/*.js'
find samples autoit-opencv-com/udf autoit-addon -type d -name 'BackUp' -prune -o -type f -name '*.au3' -not -name 'Table.au3' -a -not -name '*test.au3' -a -not -name 'Find-Contour-Draw-Demo.au3' -print | xargs -I '{}' 'C:\Program Files (x86)\AutoIt3\AutoIt3.exe' 'C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3' //Tidy //in '{}'
find samples autoit-opencv-com/udf autoit-addon -type d -name 'BackUp' | xargs -I '{}' rm -rf '{}'


# ================================
# generate doctoc
# ================================
node node_modules/doctoc/doctoc.js README.md && dos2unix README.md


# ================================
# create a new version
# ================================
npm version patch


# ================================
# build
# ================================
rm -rf opencv-4.*.0-windows autoit-opencv-com/{build_x64,generated,opencv-4.*.0-build_x64} && \
set -o pipefail && \
time CMAKE_BUILD_TYPE=Release ./autoit-*-com/build.bat && time CMAKE_BUILD_TYPE=Debug ./autoit-*-com/build.bat && \
time CMAKE_BUILD_TYPE=Release ./autoit-addon/build.bat && time CMAKE_BUILD_TYPE=Debug ./autoit-addon/build.bat && \
find samples autoit-opencv-com/udf autoit-addon -type d -name 'BackUp' -prune -o -type f -name '*.au3' -not -name 'Table.au3' -a -not -name '*test.au3' -a -not -name 'Find-Contour-Draw-Demo.au3' -print | xargs -I '{}' 'C:\Program Files (x86)\AutoIt3\AutoIt3.exe' 'C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3' //Tidy //in '{}' && \
find samples autoit-opencv-com/udf autoit-addon -type d -name 'BackUp' | xargs -I '{}' rm -rf '{}' && \
dos2unix autoit-opencv-com/udf/docs.md README.md


# ================================
# test local
# ================================
node scripts/test.js --bash > $(for ifile in autoit-*-com/build_x64/bin; do echo $ifile/test_all.sh; done) && \
./autoit-*-com/build_x64/bin/test_all.sh


# ================================
# pack release
# ================================
node scripts/build.js


# ================================
# test release
# ================================
test -d /d/Programs/AutoIt/UDF/opencv-udf-test/opencv-4.10.0-windows || ./opencv-4.10.0-windows.exe -o/d/Programs/AutoIt/UDF/opencv-udf-test/opencv-4.10.0-windows -y && \
rm -rf /d/Programs/AutoIt/UDF/opencv-udf-test/autoit-* /d/Programs/AutoIt/UDF/opencv-udf-test/samples && \
git archive --format zip --output /d/Programs/AutoIt/UDF/opencv-udf-test/autoit-opencv-com.zip main && \
7z x autoit-opencv-*.7z -aoa -o/d/Programs/AutoIt/UDF/opencv-udf-test/autoit-opencv-com && \
7z x /d/Programs/AutoIt/UDF/opencv-udf-test/autoit-opencv-com.zip -aoa -o/d/Programs/AutoIt/UDF/opencv-udf-test 'autoit-addon\*' 'samples\*' && \
node scripts/test.js --bash /d/Programs/AutoIt/UDF/opencv-udf-test > $(for ifile in autoit-*-com/build_x64/bin; do echo $ifile/test_all.sh; done) && \
./autoit-*-com/build_x64/bin/test_all.sh


# ================================
# test release with dlib
# ================================
rm -rf /d/development/git/node-autoit-dlib-com/autoit-opencv-com && \
cp -f autoit-opencv-*.7z /d/development/git/node-autoit-dlib-com/ && \
7z x autoit-opencv-*.7z -aoa -o/d/development/git/node-autoit-dlib-com/autoit-opencv-com


# ================================
# test release with mediapipe
# ================================
rm -rf /d/development/git/node-autoit-mediapipe-com/autoit-opencv-com && \
cp -f autoit-opencv-*.7z /d/development/git/node-autoit-mediapipe-com/ && \
7z x autoit-opencv-*.7z -aoa -o/d/development/git/node-autoit-mediapipe-com/autoit-opencv-com
