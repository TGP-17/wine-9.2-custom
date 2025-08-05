#!/bin/bash
REAL_CLANG_PLUS_PLUS="/usr/local/lib/android/sdk/ndk/27.2.12479018/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++"

# Filter out -mabi=ms
ARGS=()
for arg in "$@"; do
    if [[ "$arg" != "-mabi=ms" ]]; then
        ARGS+=("$arg")
    fi
done

# Call the real clang with modified args
exec "$REAL_CLANG_PLUS_PLUS" "${ARGS[@]}"
