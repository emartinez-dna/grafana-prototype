environmentName="${1:-dev}"
scriptPath=`dirname $BASH_SOURCE`

srcPath=`realpath $scriptPath/../src/`
distPath=`realpath $scriptPath/../dist/`

pushd $srcPath

rm -rf $distPath
mkdir -p $distPath/dashboards

grafonnetLibLocation="$srcPath/dashboards/grafonnet-lib"
if [ ! -d $grafonnetLibLocation ]
then
    pushd $srcPath/dashboards
    echo "Cloning grafonnet-lib..."
    git clone https://github.com/grafana/grafonnet-lib.git --quiet
    pushd grafonnet-lib
    git checkout 6db00c292d3a1c71661fc875f90e0ec7caa538c2 --quiet
    popd
    popd
fi

for sourceFile in `ls $srcPath/dashboards | grep '.*\.jsonnet'`
do
    sourceFilePath=`realpath $srcPath/dashboards/$sourceFile`;
    targetFilePath="$distPath/dashboards/`echo $sourceFile | sed 's/\.jsonnet/\.json/'`"
    jsonnet -J $srcPath/dashboards/grafonnet-lib $sourceFilePath > $targetFilePath
    echo "$sourceFilePath --> $targetFilePath"
done

cp -r $srcPath/datasources $distPath

popd