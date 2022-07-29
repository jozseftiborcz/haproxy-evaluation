#/bin/bash

WAIT_TIME=${1:-10}

while true; do
	RES=$(curl -o http_call.out -s -w "%{http_code}\n" http://localhost)
	if [ $RES -eq "429" ]; then
		echo "denied waiting for $WAIT_TIME seconds"
		sleep $WAIT_TIME
	else
		cat http_call.out
	fi
	sleep 1
done
