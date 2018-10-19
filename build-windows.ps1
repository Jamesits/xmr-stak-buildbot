cd $env:BUILD_SOURCESDIRECTORY

# download dependencies
mkdir xmr-stak-dep
Invoke-WebRequest -Uri https://github.com/fireice-uk/xmr-stak-dep/releases/download/v2/xmr-stak-dep.zip -OutFile xmr-stak-dep.zip
Expand-Archive -Path .\xmr-stak-dep.zip -DestinationPath .

# get source
git clone https://github.com/fireice-uk/xmr-stak.git xmr-stak
$DonateLevelDef = Get-Content xmr-stak/xmrstak/donate-level.hpp | %{$_ -replace "2\.0", "0.0"}
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.Environment]::CurrentDirectory = (Get-Location).Path
[System.IO.File]::WriteAllLines("xmr-stak/xmrstak/donate-level.hpp", $DonateLevelDef, $Utf8NoBomEncoding)

# compile
. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" amd64 10.0.15063.0 -vcvars_ver=14.11
. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsMSBuildCmd.bat"
$env:CMAKE_PREFIX_PATH="$env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\hwloc;$env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\libmicrohttpd;$env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\openssl"

cd $env:BUILD_BINARIESDIRECTORY
cmake -G "Visual Studio 15 2017 Win64" -T v141,host=x64 -- -DXMR-STAK_COMPILE=generic -DCMAKE_LINK_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DMICROHTTPD_ENABLE=ON -DOpenSSL_ENABLE=ON -DCPU_ENABLE=ON -DHWLOC_ENABLE=ON -DOpenCL_ENABLE=OFF -DCUDA_ENABLE=OFF $env:BUILD_SOURCESDIRECTORY\xmr-stak
cmake --build $env:BUILD_BINARIESDIRECTORY --config Release --target install
copy $BUILD_BINARIESDIRECTORY\Bin\Release\* $BUILD_ARTIFACTSTAGINGDIRECTORY
copy $env:BUILD_SOURCESDIRECTORY\xmr-stak-dep\openssl\bin\* $BUILD_ARTIFACTSTAGINGDIRECTORY
