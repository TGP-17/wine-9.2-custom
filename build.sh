export API=28

#Usage example
#DEPS=/data/data/com.termux/files/usr ARCH="x86_64" WINARCH="x86_64,i386" ./build.sh --build

#Put a x86_64 Termux styled prefix inside this folder with all the wine dependencies
export deps=$DEPS

export install_dir=$deps/../opt/wine
export TOOLCHAIN=/usr/local/lib/android/sdk/ndk/27.2.12479018/toolchains/llvm/prebuilt/linux-x86_64/bin
export LLVM_MINGW_TOOLCHAIN=/opt/llvm-mingw/bin
export TARGET=$ARCH-linux-android
export WINEARCH=$WINARCH
export PATH=$LLVM_MINGW_TOOLCHAIN:$PATH

export CC="$TOOLCHAIN/clang --target=$TARGET$API"
export AS=$CC
export CXX="$TOOLCHAIN/clang++ --target=$TARGET$API"
export AR=$TOOLCHAIN/llvm-ar
export LD=$TOOLCHAIN/ld
export RANLIB=$TOOLCHAIN/llvm-ranlib
export STRIP=$TOOLCHAIN/llvm-strip
export DLLTOOL=$LLVM_MINGW_TOOLCHAIN/llvm-dlltool

export PKG_CONFIG_LIBDIR=$deps/lib/pkgconfig:$deps/share/pkgconfig
export ACLOCAL_PATH=$deps/lib/aclocal:$deps/share/aclocal
export CPPFLAGS="-I$deps/include/"
export CFLAGS="-march=x86-64 -mtune=generic"
export CXXFLAGS="-march=x86-64 -mtune=generic"
export LDFLAGS="-L$deps/lib -Wl,-rpath=$deps/lib"
export FREETYPE_CFLAGS="-I$deps/include/freetype2"
export PULSE_CFLAGS="-I$deps/include/pulse"
export PULSE_LIBS="-L$deps/lib/pulseaudio -lpulse"
export SDL2_CFLAGS="-I$deps/include/SDL2"
export SDL2_LIBS="-L$deps/lib -lSDL2"
export X_CFLAGS="-I$deps/include"
export X_LIBS="-L$deps/lib"
export GSTREAMER_CFLAGS="-I$deps/include/gstreamer-1.0 -I$deps/include/glib-2.0 -I$deps/lib/glib-2.0/include -I$deps/lib/gstreamer-1.0/include"
export GSTREAMER_LIBS="-L$deps/lib -lgstgl-1.0 -lgstapp-1.0 -lgstvideo-1.0 -lgstaudio-1.0 -lglib-2.0 -lgobject-2.0 -lgio-2.0 -lgsttag-1.0 -lgstbase-1.0 -lgstreamer-1.0"
export FFMPEG_CFLAGS="-I$deps/include/libavutil -I$deps/include/libavcodec -I$deps/include/libavformat"
export FFMPEG_LIBS="-L$deps/lib -lavutil -lavcodec -lavformat"

for arg in "$@"
do

	if [ "$arg" == "--configure" ]
	then
            echo -e "Configuring"
            ../configure --with-wine-tools=../wine-tools --host $TARGET --with-mingw=clang --without-ldap --without-oss --disable-win16 --disable-tests --with-pulse --with-ffmpeg --with-gstreamer --with-pthread --without-dbus --with-freetype --enable-wineandroid_drv=no --without-cups --without-v4l2 --enable-nls --disable-tests --without-capi --without-coreaudio --without-gettext --with-gettextpo=no --without-gphoto --without-inotify --without-netapi --without-opencl --without-oss --without-pcap --without-sane --without-udev --without-unwind --without-usb --without-xfixes --without-xcomposite --without-xcursor --without-xinerama --without-xinput --without-xinput2 --without-xrandr --without-xrender --without-xshape --without-xshm --without-xxf86vm --enable-archs=$WINEARCH --without-wayland --without-pcsclite --prefix $install_dir --bindir $install_dir/bin --libdir $install_dir/lib --exec-prefix $install_dir || exit
    fi
	if [ "$arg" == "--build" ]
        then
            echo -e "Building"
            rm -rf $HOME/wine-build
            rm -rf $install_dir
            make -j4 install || exit
        fi
        if [ "$arg" == "--compress" ]
        then
            echo -e "Compressing"
            mkdir -p $HOME/wine-build/bin
            mkdir -p $HOME/wine-build/lib
            mkdir -p $HOME/wine-build/share
            cp -r $install_dir/bin/wine* $HOME/wine-build/bin
            cp -r $install_dir/bin/reg* $HOME/wine-build/bin
            cp -r $install_dir/bin/msi* $HOME/wine-build/bin
            cp -r $install_dir/bin/notepad $HOME/wine-build/bin
            cp -r $install_dir/lib/wine  $HOME/wine-build/lib
            cp -r $install_dir/share/wine  $HOME/wine-build/share
            rm -rf $HOME/wine-build.tar.xz
            tar -Jcf $HOME/wine-build.tar.xz -C $HOME/wine-build bin lib share
        fi
done

cd ..
