#!/bin/sh
set -e

source /hbb_shlib/activate

cd /

## Python build
curl -L -O https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tar.xz

tar -xf Python-3.13.0.tar.xz
cd Python-3.13.0

sed -i 's|-lssl -lcrypto|-lssl -lcrypto -lz -ldl|' configure

ZLIB_CFLAGS="$STATICLIB_CFLAGS" ZLIB_LIBS="$LDFLAGS -lz" BZIP2_CFLAGS="$STATICLIB_CFLAGS" BZIP2_LIBS="$LDFLAGS -lbz2" LIBLZMA_CFLAGS="$STATICLIB_CFLAGS" LIBLZMA_LDFLAGS="$LDFLAGS" LIBFFI_CFLAGS="$STATICLIB_CFLAGS" LIBFFI_LIBS="$LDFLAGS -lffi" LIBUUID_CFLAGS="$STATICLIB_CFLAGS" LIBUUID_LIBS="$LDFLAGS -luuid" LIBSQLITE3_CFLAGS="$STATICLIB_CFLAGS" LIBSQLITE3_LIBS="$LDFLAGS -lm -lsqlite3" CURSES_CFLAGS="$STATICLIB_CFLAGS" CURSES_LIBS="$LDFLAGS -lformw -lmenuw -lncursesw -lpanelw -ltic -ltinfo" LIBREADLINE_CFLAGS="$STATICLIB_CFLAGS" LIBREADLINE_LIBS="$LDFLAGS -lreadline -ltinfo" ./configure --prefix=$PWD/_install --with-openssl=/hbb_shlib --enable-optimizations

make -j12
make install

rm -rf /image/python*
cp -r _install /image/python-3.13.0-amd64

cd /image

tar cfz python-3.13.0-amd64.tar.gz python-3.13.0-amd64
rm -rf python-3.13.0-amd64
