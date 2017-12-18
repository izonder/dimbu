#!/bin/bash

usage() { echo "Usage: $0 -r <repo prefix> [-a <build args for Docker image>]" 1>&2; exit 1; }

while getopts ":r:a:" o; do
    case "${o}" in
        r)
            REPO=${OPTARG}
            ;;
        a)
            ARGS=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${REPO:-}" ]; then
    usage
fi

echo '====== Dimbu ======'
echo
echo '*** STEP 1. Initialization ***'
echo

ROOT=`pwd`
CONFIG="${ROOT}/package.json"
IMG_NAME=`cat ${CONFIG} | grep '"name"' | awk 'BEGIN{FS="\""} {print $4}'`
IMG_VER=`cat ${CONFIG} | grep '"version"' | awk 'BEGIN{FS="\""} {print $4}'`
IMG_TAG="${REPO:-}${IMG_NAME}"

echo "Package: ${IMG_NAME}@${IMG_VER}"

echo
echo '*** STEP 2. Building ***'
echo

docker build --no-cache --pull -t ${IMG_NAME} ${ARGS:-} ${ROOT}

if [ $? -eq 0 ]
then
    echo "Building finished successfully!"
else
    echo "Building failed :("
    exit 1
fi

echo
echo '*** STEP 3. Publishing ***'
echo

echo "Tag name: ${IMG_TAG}"

read -p "Do you want to publish the image with tag 'latest'? [y/n]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Tag: ${IMG_TAG}:latest"
    docker tag ${IMG_NAME} ${IMG_TAG}:latest
    docker push ${IMG_TAG}:latest
else
    echo '...skipped'
fi

read -p "Do you want to publish the image with tag '${IMG_VER}'? [y/n]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Tag: ${IMG_TAG}:${IMG_VER}"
    docker tag ${IMG_NAME} ${IMG_TAG}:${IMG_VER}
    docker push ${IMG_TAG}:${IMG_VER}
else
    echo '...skipped'
fi

echo
echo '*** DONE! ***'
echo
