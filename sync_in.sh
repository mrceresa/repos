#!/usr/bin/env bash

source defs.sh

declare -a rsyncParam=(-avtz --delete)

mkdir -p $repoLocalDir

cd $repoLocalDir
rsync "${rsyncParam[@]}" $fasLogin@f17-test.scrye.com:/home/fedora/mrceresa/local_repo/cil/ ./
cd ..