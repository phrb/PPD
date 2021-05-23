#! /usr/bin/bash

set -e

IMAGE=erad-r-notebook:latest
CONTAINER=erad-r-notebook

function usage() {
    echo "Usage: ./docker_build.sh OPTION"
    echo -e "\t-b, --build\tBuild the docker image"
    echo -e "\t-r, --run\tStart the container and the jupyter server"
    echo -e "\t-s, --stop\tStop the container"
    echo -e "\t-rm, --remove\tStop and remove the container"
    echo -e "\t-h, --help\tPrint this message"
    exit 0
}

if [ $# -eq 0 ]
   then
   usage
   exit
fi

while test $# -gt 0
do
    case "$1" in
        -b|--build)
            sudo docker build \
                 -t $IMAGE .
            ;;
        -r|--run)
            sudo docker run -p 8888:8888 \
                 --name $CONTAINER \
                 -v "$PWD":/home/jovyan/work \
                 $IMAGE
            ;;
        -s|--stop)
            sudo docker container stop $CONTAINER
            ;;
        -rm|--remove)
            sudo docker container stop $CONTAINER
            sudo docker container rm $CONTAINER
            ;;
        --help|-h|*)
            usage
            ;;
    esac
    shift
done

exit 0
