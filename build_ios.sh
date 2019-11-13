#! /bin/sh

set -x

export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/texinfo/bin:$PATH"
export PATH="/usr/local/opt/m4/bin:$PATH"

# ./bootstrap

function compile_lib() {
    local SDK=$1
    local PLATFORM=$2
    local HOST=$3
    local SUFFIX=$4

    local DEVELOPER_DIR="$(xcode-select -p)"
    local VERSION_MIN="9.0"

    local DEVROOT="${DEVELOPER_DIR}/Platforms/${SDK}.platform/Developer"
    local SDKROOT="${DEVROOT}/SDKs/${SDK}.sdk"

    export PREFIX="$(pwd)/${SUFFIX}"
    mkdir -p ${PREFIX}

    export PATH="${DEVROOT}/usr/bin:${DEVROOT}/usr/sbin:${PATH}"

    local COMMON_FLAGS="-arch ${PLATFORM} -isysroot ${SDKROOT} -mios-version-min=${VERSION_MIN} -fembed-bitcode"

    local LOWERCASE_SDK=$(echo "${SDK}" | tr '[:upper:]' '[:lower:]')

    local LIBUNITSTRING_DIR="$(pwd)/../libunistring/.build/${LOWERCASE_SDK}"

    export CPPFLAGS="-I${PREFIX}/include ${COMMON_FLAGS} -I${SDKROOT}/usr/include -I${LIBUNITSTRING_DIR}/include -O2 -g -Wno-error=tautological-compare"
    export LDFLAGS="-L$(pwd)/lib ${COMMON_FLAGS} -L${SDKROOT}/usr/lib -L${LIBUNITSTRING_DIR}/lib -lunistring -Wno-error=unused-command-line-argument"

    ./configure \
        --prefix="${PREFIX}" \
        --host=${HOST} \
        --disable-shared \
        --disable-dependency-tracking \
        --disable-doc \
        --with-libunistring-prefix="${LIBUNITSTRING_DIR}"
    make -j 10
    make install
    make clean
    make distclean
}

compile_lib iPhoneOS          arm64   arm-apple-darwin    .build/iphoneos-arm64
compile_lib iPhoneOS          armv7   arm-apple-darwin    .build/iphoneos-armv7
compile_lib iPhoneOS          armv7s  arm-apple-darwin    .build/iphoneos-armv7s
compile_lib iPhoneSimulator   i386    i686-apple-darwin   .build/iphonesimulator-i386
compile_lib iPhoneSimulator   x86_64  x86_64-apple-darwin .build/iphonesimulator-x86_64

PRODUCT_NAME=libidn2.a

mkdir -p .build/iphoneos/lib .build/iphonesimulator/lib
cp -R .build/iphoneos-arm64/include .build/iphoneos/
cp -R .build/iphonesimulator-i386/include .build/iphonesimulator/
lipo -create .build/iphoneos-{arm64,armv7,armv7s}/lib/${PRODUCT_NAME} -output .build/iphoneos/lib/${PRODUCT_NAME}
lipo -create .build/iphonesimulator-{i386,x86_64}/lib/${PRODUCT_NAME} -output .build/iphonesimulator/lib/${PRODUCT_NAME}
