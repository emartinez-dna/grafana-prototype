environmentName="${1:-dev}"
destination="${2:-host.docker.internal:9092}" # make sure to keep this default value in sync with docker-compose.yml
username="${3:-admin}"
password="${4:-admin}"
protocol="${5:-http}"

scriptPath=`dirname $BASH_SOURCE`
distPath=`realpath $scriptPath/../dist`

restCommand() {
    payload=$1
    urlSegment=$2
    method="${3:-GET}"

    fullUrl="$protocol://$username:$password@$destination/$urlSegment"

    echo "${method}ing $fullUrl"

    curl -X $method \
        -H 'Content-Type: application/json' \
        -d "${payload}" \
       $fullUrl
}

pushd $distPath

# update data sources first.
for jsonFile in `find $distPath/datasources | grep '.*\.json'`
do
    # delete each data source if it exists
    restCommand '' "api/datasources/name/`jq -r '.name' $jsonFile`" 'DELETE'

    # redeploy it.
    restCommand "$(jq . $jsonFile)" 'api/datasources' 'POST'
done

# update dashboards next
for jsonFile in `find $distPath/dashboards | grep '.*\.json'`
do
    payload=
    restCommand "{\"dashboard\": $(jq . $jsonFile), \"overwrite\": true}" 'api/dashboards/db' 'POST'
done

popd