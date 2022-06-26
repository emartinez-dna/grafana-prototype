environmentName="${1:-dev}"
scriptPath=`dirname $BASH_SOURCE`

beginningLocation=`pwd`
cd $srcPath

srcPath=`realpath $scriptPath/../src/`
distPath=`realpath $scriptPath/../dist/`

rm -rf $distPath
mkdir -p $distPath

grafonnetLibLocation="$srcPath/grafonnet-lib"
if [ ! -d $grafonnetLibLocation ]
then
    echo "Cloning grafonnet-lib..."
    git clone https://github.com/grafana/grafonnet-lib.git --quiet
    cd grafonnet-lib
    git checkout 6db00c292d3a1c71661fc875f90e0ec7caa538c2 --quiet
    cd $srcPath
fi

for sourceFile in `ls $srcPath | grep '.*\.jsonnet'`
do
    sourceFilePath=`realpath $srcPath/$sourceFile`;
    targetFilePath="$distPath/`echo $sourceFile | sed 's/\.jsonnet/\.json/'`"
    jsonnet -J $srcPath/grafonnet-lib $sourceFilePath > $targetFilePath
    echo "$sourceFilePath --> $targetFilePath"
done

cd $beginningLocation