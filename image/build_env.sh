#!/bin/sh

set -e

BZIP2_VERSION=1.0.8
FFI_VERSION=3.4.6
XZ_VERSION=5.6.3
UUID_VERSION=1.0.3
NCURSES_VERSION=6.3
READLINE_VERSION=8.2

# Helper functions
source /hbb_build/functions.sh

MAKE_CONCURRENCY=2
VARIANTS='exe shlib'

### bzip2

function install_bzip2()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing bzip2 $BZIP2_VERSION static libraries: $VARIANT"
	download_and_extract bzip2-$BZIP2_VERSION.tar.gz \
		bzip2-$BZIP2_VERSION \
		https://sourceware.org/pub/bzip2/bzip2-$BZIP2_VERSION.tar.gz


	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"
		# shellcheck disable=SC2030,SC2031
		CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		# shellcheck disable=SC2030,SC2031
		CPPFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")

		export CFLAGS
		export CPPFLAGS 

		run sed -i "s|PREFIX=/usr/local|PREFIX=$PREFIX|" Makefile
		run sed -i 's|CFLAGS=-Wall -Winline -O2 -g $(BIGFILES)|CFLAGS:=-Wall -Winline -O2 -g $(BIGFILES) $(CFLAGS)|' Makefile

		run make -j$MAKE_CONCURRENCY
		run make install
	)

	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf bzip2-$BZIP2_VERSION
}

for VARIANT in $VARIANTS; do
	install_bzip2 "$VARIANT"
done


### ffi

function install_ffi()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing ffi $FFI_VERSION static libraries: $PREFIX"
	download_and_extract libffi-$FFI_VERSION.tar.gz \
		libffi-$FFI_VERSION \
		https://github.com/libffi/libffi/releases/download/v$FFI_VERSION/libffi-$FFI_VERSION.tar.gz \

	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"
		# shellcheck disable=SC2030,SC2031
		CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		# shellcheck disable=SC2030,SC2031
		CPPFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")

		export CFLAGS
		export CPPFLAGS 

		run ./configure --prefix=$PREFIX --enable-shared=no --enable-static=yes
		run make -j$MAKE_CONCURRENCY
		run make install
	)

	# shellcheck disable=SC2181
	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf libffi-$FFI_VERSION
}

for VARIANT in $VARIANTS; do
	install_ffi "$VARIANT"
done


### XZ

function install_xz()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing xz $XZ_VERSION static libraries: $VARIANT"
	download_and_extract xz-$XZ_VERSION.tar.gz \
		xz-$XZ_VERSION \
		https://github.com/tukaani-project/xz/releases/download/v$XZ_VERSION/xz-$XZ_VERSION.tar.gz	

	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"
		# shellcheck disable=SC2030,SC2031
		CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		# shellcheck disable=SC2030,SC2031
		CPPFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")

		export CFLAGS
		export CPPFLAGS 

		run ./configure --prefix=$PREFIX --enable-shared=no --enable-static=yes
		run make -j$MAKE_CONCURRENCY
		run make install
	)

	# shellcheck disable=SC2181
	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf xz-$XZ_VERSION
}

for VARIANT in $VARIANTS; do
	install_xz "$VARIANT"
done

### uuid

function install_uuid()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing uuid $UUID_VERSION static libraries: $VARIANT"
	download_and_extract libuuid-$UUID_VERSION.tar.gz \
		libuuid-$UUID_VERSION \
		https://sourceforge.net/projects/libuuid/files/libuuid-$UUID_VERSION.tar.gz/download

	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"
		# shellcheck disable=SC2030,SC2031
		CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		# shellcheck disable=SC2030,SC2031
		CPPFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")

		export CFLAGS
		export CPPFLAGS 

		run ./configure --prefix=$PREFIX --enable-shared=no --enable-static=yes
		run make -j$MAKE_CONCURRENCY
		run make install

		run cp $PREFIX/include/uuid/* $PREFIX/include/
	)

	# shellcheck disable=SC2181
	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf libuuid-$UUID_VERSION
}

for VARIANT in $VARIANTS; do
	install_uuid "$VARIANT"
done


## ncurses
## https://svnweb.mageia.org/packages/cauldron/ncurses/releases/6.5/20240831.1.mga10/SPECS/
## https://svnweb.mageia.org/packages/cauldron/ncurses/releases/6.5/20240831.1.mga10/SPECS/ncurses.spec?revision=2093632&view=co


function install_ncurses()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing ncurses $NCURSES_VERSION static libraries: $VARIANT"
	download_and_extract ncurses-$NCURSES_VERSION.tar.gz \
		ncurses-$NCURSES_VERSION \
		https://invisible-island.net/archives/ncurses/ncurses-$NCURSES_VERSION.tar.gz

	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"
		# shellcheck disable=SC2030,SC2031
		CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		# shellcheck disable=SC2030,SC2031
		CPPFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")

		export CFLAGS
		export CPPFLAGS 

		run ./configure --prefix=$PREFIX --without-shared --with-normal --without-debug --disable-overwrite --without-profile --enable-getcap --enable-const --enable-hard-tabs --enable-no-padding --enable-sigwinch --without-ada --enable-xmc-glitch --enable-colorfgbg --enable-pc-files --with-termlib=tinfo --with-ticlib=tic --disable-tic-depends --with-ospeed=unsigned --with-xterm-kbs=DEL --disable-stripping --enable-widec
		run make -j$MAKE_CONCURRENCY
		run make install

		run cp -r $PREFIX/include/ncursesw $PREFIX/include/ncurses
		run cp $PREFIX/include/ncursesw/* $PREFIX/include/
	)

	# shellcheck disable=SC2181
	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf ncurses-$NCURSES_VERSION
}

for VARIANT in $VARIANTS; do
	install_ncurses "$VARIANT"
done


### readline

function install_readline()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing readline $READLINE_VERSION static libraries: $VARIANT"
	download_and_extract readline-$READLINE_VERSION.tar.gz \
		readline-$READLINE_VERSION \
		ftp://ftp.gnu.org/gnu/readline/readline-$READLINE_VERSION.tar.gz

	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"
		# shellcheck disable=SC2030,SC2031
		CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		# shellcheck disable=SC2030,SC2031
		CPPFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")

		export CFLAGS
		export CPPFLAGS 

		run ./configure --prefix=$PREFIX --enable-shared=no --enable-static=yes --with-curses
		run make -j$MAKE_CONCURRENCY
		run make install
	)

	# shellcheck disable=SC2181
	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf readline-$READLINE_VERSION
}

for VARIANT in $VARIANTS; do
	install_readline "$VARIANT"
done


### Finalize

header "Finalizing"
run rm -rf /hbb/share/doc /hbb/share/man
run rm -rf /hbb_build /tmp/*
for VARIANT in $VARIANTS; do
	run rm -rf "/hbb_$VARIANT/share/doc" "/hbb_$VARIANT/share/man"
done
