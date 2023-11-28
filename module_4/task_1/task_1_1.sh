DEFAULT_ALERT_FREE_SPACE_GB=5

if [ $# -eq 1 ]; then
    ALERT_FREE_SPACE_GB="$1"
else
    ALERT_FREE_SPACE_GB=$DEFAULT_ALERT_FREE_SPACE_GB
fi

checkSpace() {
    availableSpaceGb=$(df -h / | awk 'NR==2 {print $4}')
    availableSpaceKb=$(df -k / | awk 'NR==2 {print $4}')
    ALERT_FREE_SPACE_KB=$((ALERT_FREE_SPACE_GB * 1024 * 1024))
    
    if [ "$availableSpaceKb" -lt "$ALERT_FREE_SPACE_KB" ]; then
        echo "WARNING: Available disk space is less than $ALERT_FREE_SPACE_GB GB ($availableSpaceGb)"
    fi
}

while true; do
    checkSpace
    sleep 10
done

