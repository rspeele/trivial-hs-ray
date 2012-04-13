#!/bin/sh
PROG=$1
RTSOPT=$2
rm -f *.o *.hi *.aux
ghc --make -prof -auto-all -O2 -threaded -rtsopts -with-rtsopts=-N1 $PROG
./$PROG +RTS -pa $RTSOPT -L75 < All.sce > test.tga
hp2ps -c $PROG.hp
gv $PROG.ps -orientation=seascape &