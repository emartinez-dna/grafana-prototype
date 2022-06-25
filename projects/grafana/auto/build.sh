environmentName="${1:-dev}"
scriptPath=`dirname $BASH_SOURCE`

grafonnetLibLocation="$scriptPath/../src/grafonnet-lib"
if [ ! -d $grafonnetLibLocation ]
then
    echo "Cloning grafonnet-lib..."
    beginningLocation=`pwd`
    cd $scriptPath/../src/
    git clone https://github.com/grafana/grafonnet-lib.git --quiet
    cd grafonnet-lib
    git checkout 6db00c292d3a1c71661fc875f90e0ec7caa538c2 --quiet
    cd $beginningLocation
fi

sleep 3 # simulates a build step