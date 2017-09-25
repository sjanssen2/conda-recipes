#!/bin/bash

case "$(uname)" in
    Linux)
        wget http://github.com/bbuchfink/diamond/releases/download/v0.7.10/diamond-linux64.tar.gz
        tar xzf diamond-linux64.tar.gz
        mv diamond $PREFIX/bin
        ;;
    Darwin)
        cd src
        ./install-boost &> /dev/null
        #sed -i "" "s/-march=native/ /g" Makefile
		patch Makefile < ../boost.patch
        make CXXFLAGS="-O3 -DNDEBUG -Iboost/include $(WARN) -I$PREFIX/include/" LDFLAGS="-L$PREFIX/lib/"
        mkdir -p $PREFIX/bin
        cp ../bin/diamond $PREFIX/bin
        ;;
esac
