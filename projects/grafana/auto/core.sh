restCommand() {
    username=$1
    password=$2
    protocol=$3
    destination=$4
    payload=$5
    urlSegment=$6
    method="${7:-GET}"

    authorization_section=''

    # we're doing this because if we don't pass either a username or password, then omit the whole authorization section of the request entirely.
    if [[ ! -z $username && ! -z $password ]]
    then
        authorization_section="$username:$password"
    fi

    fullUrl="$protocol://$authorization_section@$destination/$urlSegment"

    curl --silent -X $method \
    -H 'Content-Type: application/json' \
    -d "${payload}" \
    "$fullUrl"
}
