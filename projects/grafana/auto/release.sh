environmentName="${1:-dev}"
destination="${2:-host.docker.internal:9092}" # make sure to keep this default value in sync with docker-compose.yml
username="${3:-admin}"
password="${4:-admin}"
protocol="${5:-http}"

scriptPath=`dirname $BASH_SOURCE`
distPath=`realpath $scriptPath/../dist`

pushd $distPath

# first post data sources
for jsonFile in `ls $distPath/datasources | grep '.*\.json'`
do
    :
done

# second post dashboards
for jsonFile in `find $distPath/dashboards | grep '.*\.json'`
do
    echo "POSTing $jsonFile to $destination"
    payload="{\"dashboard\": $(jq . $jsonFile), \"overwrite\": true}"

    fullUrl="$protocol://$username:$password@$destination/api/dashboards/db"

    curl -X POST \
        -H 'Content-Type: application/json' \
        -d "${payload}" \
       $fullUrl
done

popd