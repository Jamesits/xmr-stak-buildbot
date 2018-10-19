cd $env:BUILD_SOURCESDIRECTORY

# build hwloc
git clone https://github.com/open-mpi/hwloc.git
cd hwloc
Get-ChildItem contrib/windows -Filter "*.vcxproj" | Foreach-Object {
    . msbuild $_.FullName
}
