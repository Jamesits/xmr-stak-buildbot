Set-PSDebug -Trace 1

cd $env:BUILD_SOURCESDIRECTORY

# download dependencies
mkdir xmr-stak-dep
Invoke-WebRequest -Uri https://github.com/fireice-uk/xmr-stak-dep/releases/download/v2/xmr-stak-dep.zip -OutFile xmr-stak-dep.zip
Expand-Archive -Path .\xmr-stak-dep.zip -DestinationPath .

# get source
git clone https://github.com/fireice-uk/xmr-stak.git xmr-stak
Get-Content xmr-stak/xmrstak/donate-level.hpp | %{$_ -replace "2\.0", "0.0"} | Out-File -FilePath xmr-stak/xmrstak/donate-level.hpp -Encoding utf8

# compile
. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=14.11
. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsMSBuildCmd.bat"
set CMAKE_PREFIX_PATH="$env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\hwloc;$env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\libmicrohttpd;$env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\openssl"

cd $env:BUILD_BINARIESDIRECTORY
cmake -G "Visual Studio 15 2017 Win64" -T v141,host=x64 $env:BUILD_SOURCESDIRECTORY\xmr-stak
cmake --build $env:BUILD_SOURCESDIRECTORY\xmr-stak --config Release --target install -- -DXMR-STAK_COMPILE=generic -DCMAKE_LINK_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DMICROHTTPD_ENABLE=ON -DOpenSSL_ENABLE=ON -DCPU_ENABLE=ON -DHWLOC_ENABLE=ON -DOpenCL_ENABLE=OFF -DCUDA_ENABLE=OFF
copy $BUILD_BINARIESDIRECTORY\Bin\Release\* $BUILD_ARTIFACTSTAGINGDIRECTORY
copy $env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\openssl\bin\* $BUILD_ARTIFACTSTAGINGDIRECTORY
