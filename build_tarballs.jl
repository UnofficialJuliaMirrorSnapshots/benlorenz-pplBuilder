# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build pplBuilder
sources = [
    "http://www.bugseng.com/products/ppl/download/ftp/releases/1.2/ppl-1.2.tar.bz2" =>
    "2d470b0c262904f190a19eac57fb5c2387b1bfc3510de25a08f3c958df62fdf1",
    "./bundled",
]
name = "ppl"
version = v"1.2"

# Bash recipe for building across all platforms
script = raw"""
cd ppl-1.2
atomic_patch -p2 "${WORKSPACE}/srcdir/patches/patch-v1.2.diff"
# avoid libtool problems ....
rm /workspace/destdir/lib/libgmpxx.la
./configure --prefix=$prefix --host=$target --enable-interfaces=cxx --enable-static=no --enable-documentation=no --with-gmp=$prefix
make -j
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libppl", :libppl)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/GMP-v6.1.2-1/build_GMP.v6.1.2.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
