environmentName="${1:-dev}"
destination="${2:-host.docker.internal:9092}" # make sure to keep this default value in sync with docker-compose.yml
username="${3:-admin}"
password="${4:-admin}"
protocol="${5:-http}"

scriptPath=`dirname $BASH_SOURCE`
source "$scriptPath/core.sh"

restCommand $username $password $protocol $destination '' 'api/search?query=%' 'GET'