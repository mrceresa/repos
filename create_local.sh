#!/usr/bin/env bash

source defs.sh

IFS=",$IFS"
eval mkdir -pv $repoLocalDir/{"${branches[*]}"}/{"${rpmdir[*]}"}