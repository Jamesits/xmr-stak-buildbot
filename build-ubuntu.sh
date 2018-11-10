#!/bin/bash
set -euv
export DEBIAN_FRONTEND=noninteractive

# install packages
sudo apt-get update -y
sudo apt-get install -y git-core cmake build-essential libmicrohttpd-dev libssl-dev libhwloc-dev liblzma-dev

# get source
cd $BUILD_SOURCESDIRECTORY
git clone https://github.com/fireice-uk/xmr-stak.git xmr-stak
sed -ie "s/2\.0/0\.0/g" xmr-stak/xmrstak/donate-level.hpp

# compile
cd $BUILD_BINARIESDIRECTORY
cmake $BUILD_SOURCESDIRECTORY/xmr-stak -DXMR-STAK_COMPILE=generic -DCMAKE_LINK_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DMICROHTTPD_ENABLE=ON -DOpenSSL_ENABLE=ON -DCPU_ENABLE=ON -DHWLOC_ENABLE=ON -DOpenCL_ENABLE=OFF -DCUDA_ENABLE=OFF
make -j

# stage artifacts
mv $BUILD_BINARIESDIRECTORY/bin/* $BUILD_ARTIFACTSTAGINGDIRECTORY
rm $BUILD_ARTIFACTSTAGINGDIRECTORY/*.a
