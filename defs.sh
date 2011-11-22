#!/bin/bash

SUCCESS=0

repoLocalDir=~/ralph_repo/repos
repoDir=/var/www/fedora/cil
rpmsrcDir=~/rpmbuild/SRPMS
rpmbuildDir=/var/lib/mock
suffix="-ralph-x86_64"

declare -a rpmdir=(x86_64 noarch SRPMS)
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

echo "- Local repo is set to: "$repoLocalDir
echo "- Public repo is server from: "$repoDir
echo "- Source SRPMs are looked for into: "$rpmsrcDir
echo "- Build dir is: "$rpmbuildDir
echo "- Build will happen for targets: "$targets



