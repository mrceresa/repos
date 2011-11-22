#!/bin/bash

repoLocalDir=~/ralph_repo/repos
rpmsrcDir=~/rpmbuild/SRPMS
rpmbuildDir=/var/lib/mock
suffix="-ralph-x86_64"

declare -a targets=(fedora-14$suffix fedora-15$suffix)

build_target() {
    target=$1
    name=$2
        
    if [ -z "$target" ]
    then
        echo "Please specify target"
        return -1
    fi
                    
    if [ -z "$name" ]
    then
	echo "Please specify SRPM name (without .src.rpm)"
        return -1
    fi
    
    mock rebuild --no-clean -r $target -v $rpmsrcDir/$name*.src.rpm
    find $rpmbuildDir/$target/result/ -name "$name*.rpm" -exec cp {} $repoLocalDir/$target/x86_64/ \;
                                
}