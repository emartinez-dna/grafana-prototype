scriptPath=`dirname $BASH_SOURCE`
pollInterval="${1:-5}"
while true
do
    clear
    echo "===== `date`: Updating your source code with the latest from your local grafana ====="
    bash "$scriptPath/scrape.sh" `realpath "$scriptPath/../src"`
    
    echo ""
    echo -n "Waiting $pollInterval seconds"
    for (( seconds=0; seconds < $pollInterval; seconds++ ))
    do
        echo -n '.'
        sleep 1
    done
done

