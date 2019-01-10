#!/bin/bash
set -euv

# install dependencies
# brew may fail because package is already installed
! brew install hwloc libmicrohttpd gcc openssl cmake
# brew may fail on first try but magically work the second time
# source: https://qiita.com/takuyanin/items/22e689a554643f7650db
! brew install hwloc libmicrohttpd gcc openssl cmake
# if they are already installed, we try to upgrade them
! brew upgrade hwloc libmicrohttpd gcc openssl cmake

# get source
cd $BUILD_SOURCESDIRECTORY
git clone https://github.com/fireice-uk/xmr-stak.git xmr-stak
sed -ie "s/2\.0/0\.0/g" xmr-stak/xmrstak/donate-level.hpp

# compile
cd $BUILD_BINARIESDIRECTORY
cmake $BUILD_SOURCESDIRECTORY/xmr-stak -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl -DXMR-STAK_COMPILE=generic -DCMAKE_LINK_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DMICROHTTPD_ENABLE=ON -DOpenSSL_ENABLE=ON -DCPU_ENABLE=ON -DHWLOC_ENABLE=ON -DOpenCL_ENABLE=ON -DCUDA_ENABLE=OFF
make -j

# stage artifacts
mv $BUILD_BINARIESDIRECTORY/bin/* $BUILD_ARTIFACTSTAGINGDIRECTORY
rm $BUILD_ARTIFACTSTAGINGDIRECTORY/*.a
