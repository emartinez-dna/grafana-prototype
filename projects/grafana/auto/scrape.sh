environmentName="${1:-dev}"
destination="${2:-host.docker.internal:9092}" # make sure to keep this default value in sync with docker-compose.yml
username="${3:-admin}"
password="${4:-admin}"
protocol="${5:-http}"
out_dir=$6

if [ -z $out_dir ]
then
    echo "out_dir is required."
    exit 1
else
    out_dir=`realpath $out_dir`
    mkdir -p $out_dir
fi

scriptPath=`dirname $BASH_SOURCE`
source "$scriptPath/core.sh"

uids=`restCommand $username $password $protocol $destination '' 'api/search?query=%' 'GET' | jq '.[].uid' --raw-output`
declare -a parallelized_commands=()

for uid in $uids
do
    # for every command, import core.sh and execute the restCommand for pulling the dashboard json by uid.
    # we run the resulting json through jq and make sure to remove the id field.  This id field wouldn't persist across environments, so we want to avoid capturing that in the source code.
    parallelized_commands+=("source $scriptPath/core.sh; restCommand '$username' '$password' '$protocol' '$destination' '' 'api/dashboards/uid/$uid' 'GET' | jq 'del(.dashboard.id)' > '$out_dir/$uid.json'")
done

num_cores=`nproc --all`
parallelism=$(( $num_cores * 4 ))
echo "Pulling ${#parallelized_commands[@]} dashboards from $destination with parallelism of $parallelism and placing them in $out_dir."
execution_time=`(time printf '%s\n' "${parallelized_commands[@]}" | parallel --jobs $parallelism bash -c) 2>&1 | awk '/^real/{print $2}'`

echo "Done!  Operation took $execution_time."