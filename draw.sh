#!/bin/sh
RTSOPTS=""
PAROPTS=""
if [ x$2 = xbench ]; then
    echo "Recompiling for benchmark run..."
    rm *.o
    PAROPTS="-rtsopts"
    RTSOPTS="+RTS -sstderr -RTS"
    if [ x$3 = xpar ]; then
	echo "Compiling for multicore..."
	PAROPTS="-threaded -rtsopts -with-rtsopts=-N4"
    fi
fi
ghc --make Render -O2 -fspec-constr-count5 $PAROPTS
./Render $RTSOPTS < $1 > test.tga
feh test.tga
