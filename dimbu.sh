#!/bin/bash

usage() { echo "Usage: $0 -r <repo prefix> [-a <build args for Docker image>][-s (silent mode)]" 1>&2; exit 1; }

SILENT=0
while getopts ":r:a:s" o; do
    case "${o}" in
        r)
            REPO=${OPTARG}
            ;;
        a)
            ARGS=${OPTARG}
            ;;
        s)
            SILENT=1
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

publish() {
    echo "Tag: ${IMG_TAG}:$1"
    docker tag ${IMG_NAME} ${IMG_TAG}:$1
    docker push ${IMG_TAG}:$1
}

echo "Tag name: ${IMG_TAG}"

if [[ $SILENT = 0 ]]
then
    read -p "Do you want to publish the image with tag 'latest'? [y/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        publish latest
    else
        echo '...skipped'
    fi
else
    publish latest
fi

if [[ $SILENT = 0 ]]
then
    read -p "Do you want to publish the image with tag '${IMG_VER}'? [y/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        publish ${IMG_VER}
    else
        echo '...skipped'
    fi
else
    publish ${IMG_VER}
fi

echo
echo '*** DONE! ***'
echo
