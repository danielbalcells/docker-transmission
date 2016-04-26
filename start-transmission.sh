#! /bin/bash
echo 'SOME_PASSWORD' | sudo -S service transmission-daemon start
while :
do
	sleep 100
done
