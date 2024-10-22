#!/bin/sh
set -e

source /hbb_shlib/activate

cd /

## bzip2-devel.x86_64
curl -L -O https://sourceware.org/pub/bzip2/bzip2-latest.tar.gz

tar -xf bzip2-latest.tar.gz
rm  -f  bzip2-latest.tar.gz

cd bzip2-1.0.8

sed -i 's|PREFIX=/usr/local|PREFIX=/hbb_shlib|' Makefile
sed -i 's|CFLAGS=-Wall -Winline -O2 -g $(BIGFILES)|CFLAGS:=-Wall -Winline -O2 -g $(BIGFILES) $(STATICLIB_CFLAGS)|' Makefile
make -j2
make install

cd /

## libffi-devel.x86_64
curl -L -O https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz

tar -xf libffi-3.4.6.tar.gz
rm  -f  libffi-3.4.6.tar.gz

cd libffi-3.4.6

CFLAGS="$STATICLIB_CFLAGS" CPPFLAGS="$STATICLIB_CFLAGS" ./configure --prefix=/hbb_shlib --enable-shared=no --enable-static=yes
make -j2
make install

cd /

## xz-devel.x86_64
curl -L -O https://github.com/tukaani-project/xz/releases/download/v5.6.3/xz-5.6.3.tar.gz

tar -xf xz-5.6.3.tar.gz
rm  -f  xz-5.6.3.tar.gz

cd xz-5.6.3
CFLAGS="$STATICLIB_CFLAGS" CPPFLAGS="$STATICLIB_CFLAGS" ./configure --prefix=/hbb_shlib --enable-shared=no --enable-static=yes
make -j2
make install

cd /

## libuuid-devel.x86_64
curl -L -o libuuid-1.0.3.tar.gz https://sourceforge.net/projects/libuuid/files/libuuid-1.0.3.tar.gz/download

tar -xf libuuid-1.0.3.tar.gz
rm  -f  libuuid-1.0.3.tar.gz

cd libuuid-1.0.3
CFLAGS="$STATICLIB_CFLAGS" CPPFLAGS="$STATICLIB_CFLAGS" ./configure --prefix=/hbb_shlib --enable-shared=no --enable-static=yes
make -j2
make install

cp /hbb_shlib/include/uuid/* /hbb_shlib/include/

cd /

## ncurses
## https://svnweb.mageia.org/packages/cauldron/ncurses/releases/6.5/20240831.1.mga10/SPECS/
## https://svnweb.mageia.org/packages/cauldron/ncurses/releases/6.5/20240831.1.mga10/SPECS/ncurses.spec?revision=2093632&view=co
curl -L -O https://invisible-island.net/archives/ncurses/ncurses-6.5.tar.gz

tar -xf ncurses-6.5.tar.gz
rm  -f  ncurses-6.5.tar.gz

cd ncurses-6.5

CFLAGS="$STATICLIB_CFLAGS" CPPFLAGS="$STATICLIB_CFLAGS" ./configure --prefix=/hbb_shlib --without-shared --with-normal --without-debug --disable-overwrite --without-profile --enable-getcap --enable-const --enable-hard-tabs --enable-no-padding --enable-sigwinch --without-ada --enable-xmc-glitch --enable-colorfgbg --enable-pc-files --with-termlib=tinfo --with-ticlib=tic --disable-tic-depends --with-ospeed=unsigned --with-xterm-kbs=DEL --disable-stripping --enable-widec

make -j2
make install

cp -r /hbb_shlib/include/ncursesw /hbb_shlib/include/ncurses
cp /hbb_shlib/include/ncursesw/* /hbb_shlib/include/

cd /

## readline-devel.x86_64
curl -O ftp://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz

tar -xf readline-8.2.tar.gz
rm  -f  readline-8.2.tar.gz

cd readline-8.2

CFLAGS="$STATICLIB_CFLAGS" CPPFLAGS="$STATICLIB_CFLAGS" ./configure --prefix=/hbb_shlib --enable-shared=no --enable-static=yes --with-curses
make -j2
make install
