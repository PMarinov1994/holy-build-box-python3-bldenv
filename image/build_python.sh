#!/bin/sh
set -e

PYTHON_VERSION=3.13.0

# Helper functions
source /hbb_build/functions.sh

MAKE_CONCURRENCY=2
VARIANTS='shlib'

### Python

function install_python()
{
	local VARIANT="$1"
	local PREFIX="/hbb_$VARIANT"

	header "Installing python $PYTHON_VERSION : $VARIANT"
	download_and_extract Python-$PYTHON_VERSION.tar.xz \
		Python-$PYTHON_VERSION \
		https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz

	(
		# shellcheck source=/dev/null
		source "$PREFIX/activate"

		run	sed -i 's|-lssl -lcrypto|-lssl -lcrypto -lz -ldl|' configure

		# export LDFLAGS=$LDFLAGS\ -Wl,--rpath,'\$$ORIGIN/../lib'

		export ZLIB_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export ZLIB_LIBS="$LDFLAGS -lz"

		export BZIP2_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export BZIP2_LIBS="$LDFLAGS -lbz2"
	
		export LIBLZMA_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export LIBLZMA_LDFLAGS="$LDFLAGS"

		export LIBFFI_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export LIBFFI_LIBS="$LDFLAGS -lffi"

		export LIBUUID_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export LIBUUID_LIBS="$LDFLAGS -luuid"

		export LIBSQLITE3_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export LIBSQLITE3_LIBS="$LDFLAGS -lm -lsqlite3"

		export CURSES_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export CURSES_LIBS="$LDFLAGS -lformw -lmenuw -lncursesw -lpanelw -ltic -ltinfo"

		export LIBREADLINE_CFLAGS=$(adjust_optimization_level "$STATICLIB_CFLAGS")
		export LIBREADLINE_LIBS="$LDFLAGS -lreadline -ltinfo"

		run  ./configure --prefix=$PREFIX --with-openssl=$PREFIX --enable-optimizations --enable-shared

		run make -j$MAKE_CONCURRENCY
		run make install
	)

	if [[ "$?" != 0 ]]; then false; fi

	echo "Leaving source directory"
	popd >/dev/null
	run rm -rf Python-$PYTHON_VERSION
}

for VARIANT in $VARIANTS; do
	install_python "$VARIANT"
done

### Finalize

header "Finalizing"
run rm -rf /hbb/share/doc /hbb/share/man
run rm -rf /hbb_build /tmp/*
for VARIANT in $VARIANTS; do
	run rm -rf "/hbb_$VARIANT/share/doc" "/hbb_$VARIANT/share/man"
done
