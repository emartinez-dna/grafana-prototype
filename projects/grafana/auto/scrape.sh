out_dir=$1
destination="${2:-host.docker.internal:9092}" # make sure to keep this default value in sync with docker-compose.yml
username="${3:-admin}"
password="${4:-admin}"
protocol="${5:-http}"

if [ -z $out_dir ]
then
    echo "out_dir is required."
    exit 1
else
    out_dir=`realpath $out_dir`

    rm -rf $out_dir/datasources $out_dir/dashboards $out_dir/folders
    mkdir -p $out_dir/datasources $out_dir/folders $out_dir/dashboards
fi

scriptPath=`dirname $BASH_SOURCE`
source "$scriptPath/core.sh"


declare -a parallelized_commands=()
uids=`restCommand $username $password $protocol $destination '' 'api/search' 'GET' | jq '.[].uid' --raw-output`
for uid in $uids
do
    parallelized_commands+=("source $scriptPath/core.sh; restCommand '$username' '$password' '$protocol' '$destination' '' 'api/dashboards/uid/$uid' 'GET' | jq 'del(.dashboard.id)' > '$out_dir/dashboards/$uid.json'")
done

uids=`restCommand $username $password $protocol $destination '' "api/datasources" 'GET' | jq '.[].uid' --raw-output`
for uid in $uids
do
    parallelized_commands+=("source $scriptPath/core.sh; restCommand '$username' '$password' '$protocol' '$destination' '' 'api/datasources/uid/${uid}' 'GET' | jq 'del(.id)' > '$out_dir/datasources/$uid.json'")
done

uids=`restCommand $username $password $protocol $destination '' "api/folders" 'GET' | jq '.[].uid' --raw-output`
for uid in $uids
do
    parallelized_commands+=("source $scriptPath/core.sh; restCommand '$username' '$password' '$protocol' '$destination' '' 'api/folders/${uid}' 'GET' | jq 'del(.id)' > '$out_dir/folders/$uid.json'")
done

num_cores=`nproc --all`
parallelism=$(( $num_cores * 4 ))
execution_time=`(time printf '%s\n' "${parallelized_commands[@]}" | parallel --jobs $parallelism bash -c) 2>&1 | awk '/^real/{print $2}'`

echo "Done!  Operation took $execution_time."