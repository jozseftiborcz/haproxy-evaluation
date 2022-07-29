#/bin/bash

if [ -z "$1" ]; then 
	echo """usage $0 <command>
  reset   resets rate limit tables
  status  show rate limit statuses
  """
  exit 1
fi

case $1 in
	"reset")
		echo "clear table Abuse" | nc localhost 9999
		;;
	"status")
		echo "show table Abuse" | nc localhost 9999
		;;
esac
	
