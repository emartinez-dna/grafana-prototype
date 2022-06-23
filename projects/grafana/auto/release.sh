environmentName="${1:-dev}"
destination="${2:-http://host.docker.internal:3000}" # make sure to keep this default value in sync with docker-compose.yml

echo "Pushing to $destination."