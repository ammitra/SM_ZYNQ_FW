#!/bin/bash
cd /opt/ApolloHerd/herd-library
mkdir build
cd build
cmake3 -DBUILD_SHARED_LIBS=ON ..
make
cd ../../
mkdir build
cd build
cmake3 -DBUILD_SHARED_LIBS=ON ../herd-library
make
cd ..
make
