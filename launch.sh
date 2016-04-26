#! /bin/bash
# usage: ./launch.sh download_dir container_name
docker run -it --detach --net=host -p 9999 -p 51000-52000 -v $1:/home/transmission-user/transmission --name=$2 danielbalcells/transmission 
