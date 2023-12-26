#!/bin/bash
# code from https://github.com/RUB-SysSec/GANDCTAnalysis/blob/master/docker.sh
# Copyright (c) 2021 Chair for Sys­tems Se­cu­ri­ty, Ruhr University Bochum

# usage ----------------------------------------------
# bash docker.sh build  # build image
# bash docker.sh shell  # run container as user
# bash docker.sh root  # run container as root
# ----------------------------------------------------

DATASET_DIRS="$HOME/dataset"
DATA_DIRS="$HOME/data"

build_torch()
{
    # docker build . -f docker/Dockerfile.torch --build-arg USER_UID=`(id -u)` --build-arg USER_GID=`(id -g)` --no-cache -t tf63/torch:1.13.0-cu117
    docker build . -f docker/Dockerfile.torch --build-arg USER_UID=`(id -u)` --build-arg USER_GID=`(id -g)` -t tf63/torch:1.13.0-cu117
}

build_local()
{
    docker build . -f docker/Dockerfile.poetry --build-arg USER_UID=`(id -u)` --build-arg USER_GID=`(id -g)` -t tf63/poetry
}

build()
{
    build_torch
    build_local
}

shell() 
{
    docker run --rm --gpus all --user user --shm-size=16g -it -v $(pwd):/app -v $DATASET_DIRS:/dataset -v $DATA_DIRS:/data tf63/poetry /bin/bash
}

root()
{
    docker run --rm --gpus all --user root --shm-size=16g -it -v $(pwd):/app -v $DATASET_DIRS:/dataset -v $DATA_DIRS:/data tf63/poetry /bin/bash
}

if [[ $1 == "build" ]]; then
    build
elif [[ $1 == "build_torch" ]]; then
    build_torch
elif [[ $1 == "build_poetry" ]]; then
    build_poetry
elif [[ $1 == "shell" ]]; then
    shell 
elif [[ $1 == "root" ]]; then
    root
else
    echo "error: invalid argument"
fi
