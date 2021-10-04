#!/bin/bash

# force pyobjc to use conda-forge's chosen SDK
export CFLAGS="${CFLAGS} -isysroot ${SDKROOT:-$CONDA_BUILD_SYSROOT}"

# "-framework Carbon" is ignored because of this linker flag set by conda, so we remove it
export LDFLAGS=`echo "${LDFLAGS}" | sed "s/-Wl,-dead_strip_dylibs//g"`
export LDFLAGS_LD=`echo "${LDFLAGS_LD}" | sed "s/-dead_strip_dylibs//g"`

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1"  && $target_platform == osx-arm64 ]]; then
    PIP="$PREFIX/bin/python -m pip"
else
    PIP="pip"
fi
CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS LDFLAGS_LD=$LDFLAGS_LD $PIP install . --no-deps -vv
