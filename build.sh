#!/usr/bin/env bash

ANDROID_NDK_HOME=/home/andrew/opt/android-ndk
ANDROID="yes"

dest="/data/local/tmp"

if [ "$ANDROID" ]; then
  echo "compiling for Android targets"

  ARCH="armeabi-v7a"
  API="24"

  case "$ARCH" in
  "armeabi-v7a")
    PREFIX="armv7a"
    BINPREFIX="arm"
    MIDDLE="linux-androideabi"
    ;;
  "arm64-v8a")
    PREFIX="aarch64"
    BINPREFIX="aarch64"
    MIDDLE="linux-android"
    ;;
  "x86")
    PREFIX="i686"
    BINPREFIX="i686"
    MIDDLE="llinux-android"
    ;;
  "x86-64")
    PREFIX="x86_64"
    BINPREFIX="x86_64"
    MIDDLE="linux-android"
    ;;
  *)
    echo "invalid arch"
    exit
    ;;
  esac

  TRIPLE="$PREFIX-$MIDDLE"

  echo "TRIPLE = $TRIPLE"

  export TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
  export AR=$TOOLCHAIN/bin/$BINPREFIX-$MIDDLE-ar
  export AS=$TOOLCHAIN/bin/$BINPREFIX-$MIDDLE-as
  export CC=$TOOLCHAIN/bin/$PREFIX-$MIDDLE$API-clang
  export CXX=$TOOLCHAIN/bin/$PREFIX-$MIDDLE$API-clang++
  export LD=$TOOLCHAIN/bin/$BINPREFIX-$MIDDLE-ld
  export RANLIB=$TOOLCHAIN/bin/$BINPREFIX-$MIDDLE-ranlib
  export STRIP=$TOOLCHAIN/bin/$BINPREFIX-$MIDDLE-strip

  if [ ! -d "$TOOLCHAIN" ]; then
    echo "error: toolchain doesn't exist"
    exit
  elif [ ! -f "$AR" ]; then
    echo "error: AR doesn't exist"
    echo "$AR"
    exit
  elif [ ! -f "$AS" ]; then
    echo "error: AS doesn't exist"
    echo "$AS"
    exit
  elif [ ! -f "$CC" ]; then
    echo "error: CC doesn't exist"
    echo "$CC"
    exit
  elif [ ! -f "$CXX" ]; then
    echo "error: CXX doesn't exist"
    echo "$CXX"
    exit
  elif [ ! -f "$LD" ]; then
    echo "error: LD doesn't exist"
    echo "$LD"
    exit
  fi

  echo "TOOLCHAIN = $TOOLCHAIN"
  echo "AR        = $(basename "$AR")"
  echo "AS        = $(basename "$AS")"
  echo "CC        = $(basename "$CC")"
  echo "CXX       = $(basename "$CXX")"
  echo "LD        = $(basename "$LD")"

  ./autogen.sh

  ./configure \
    --prefix="$dest" \
    --with-tmpdir="$dest" \
    --host $TRIPLE \
    --target $TRIPLE

else
  echo "compiling for generic targets"

  ./autogen.sh

  ./configure \
    --prefix="$dest"
fi

make clean
make -j16
make install
