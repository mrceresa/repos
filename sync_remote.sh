#!/usr/bin/env bash

source defs.sh

declare -a rsyncParam=(-avtz --delete)

cd $repoLocalDir
for dir2 in "${branches[@]}"
do
    echo -e "\033[31mUpdate $dir2 repos:\033[0m"
    cd $dir2
    for dir3 in "${rpmdir[@]}"
    do
        echo -e "\033[34m\t* $dir3:\033[0m"
        cd $dir3
        createrepo ./
        rsync "${rsyncParam[@]}" ./* $fasLogin@fedorapeople.org:/srv/repos/$fasLogin/$repoName/$dir2/$dir3
        cd ..
    done
    cd ..
done
cd ..