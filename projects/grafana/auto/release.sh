environmentName="${1:-dev}"
destination="${2:-host.docker.internal:9092}" # make sure to keep this default value in sync with docker-compose.yml
username="${3:-admin}"
password="${4:-admin}"
protocol="${5:-http}"

scriptPath=`dirname $BASH_SOURCE`
distPath=`realpath $scriptPath/../dist`

source "$scriptPath/core.sh"

pushd $distPath

# update data sources first.
for jsonFile in `find $distPath/datasources | grep '.*\.json'`
do
    # delete each data source if it exists
    restCommand $username $password $protocol $destination '' "api/datasources/name/`jq -r '.name' $jsonFile`" 'DELETE'

    # redeploy it.
    restCommand $username $password $protocol $destination "$(jq . $jsonFile)" 'api/datasources' 'POST'
done

# update dashboards next
for jsonFile in `find $distPath/dashboards | grep '.*\.json'`
do
    restCommand $username $password $protocol $destination "`cat $jsonFile | jq '. + { overwrite: true }'`" 'api/dashboards/db' 'POST'
done

popd