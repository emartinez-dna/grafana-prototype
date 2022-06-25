environmentName="${1:-dev}"
scriptPath=`dirname $BASH_SOURCE`

srcPath=`realpath $scriptPath/../src/`
grafonnetLibLocation="$srcPath/grafonnet-lib"
if [ ! -d $grafonnetLibLocation ]
then
    echo "Cloning grafonnet-lib..."
    beginningLocation=`pwd`
    cd $srcPath
    git clone https://github.com/grafana/grafonnet-lib.git --quiet
    cd grafonnet-lib
    git checkout 6db00c292d3a1c71661fc875f90e0ec7caa538c2 --quiet
    cd $beginningLocation
fi

for sourceFile in `ls $srcPath | grep '.*\.jsonnet'`
do
    echo "Compiling $sourceFile"
done