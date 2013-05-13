#!/bin/bash

SUCCESS=0

repoDir=~/repos
rpmsrcDir=~/rpmbuild/SRPMS
rpmbuildDir=/var/lib/mock
suffix="-ralph-x86_64"

fasLogin=mario
repoLocalDir=$repoDir
repoName=cil

declare -a rpmdir=(i686 x86_64 noarch SRPMS)
declare -a branches=(fedora-18)

build_target() {
    branch=$1
    target=$2
    name=$3
    ver=$4
        
    if [ -z "$target" ]
    then
        echo "Please specify target"
        exit
    fi
                    
    if [ -z "$name" ]
    then
	echo "Please specify SRPM name (without .src.rpm)"
        exit
    fi
    srpm_pkg=$(ls -latr ~/rpmbuild/SRPMS/ralph-filters*.src.rpm | tail -n1 | cut -d' ' -f9)
    mock rebuild --no-clean -v -r $target $srpm_pkg
    
    if [ ! "$?" -eq $SUCCESS ]
    then
	echo "Can't build package "$name" retrying once..."
	mock rebuild --no-clean -v -r $target $srpm_pkg
	if [ ! "$?" -eq $SUCCESS ]
        then
	    echo "Can't build package "$name" please check!"
	    exit
	fi
    fi
    
    find $rpmbuildDir/$target/result/ -name "$name$ver*.src.rpm" -exec cp '{}' $repoDir/$branch/SRPMS/ \;
    find $rpmbuildDir/$target/result/ -name "$name*.rpm" ! -name "*.src.rpm" -exec cp '{}' $repoDir/$branch/x86_64/ \;

}

build_if_not_already() {
    branch=$1
    target=$2
    name=$3
    ver=$4
    echo "Preparing package "$name$ver" for target "$target
    num=$(find $repoDir/$branch -name "$name*" | grep -v SRPMS | wc | awk '{print $1}')
    echo "Found "$num" rpms for "$name" in repository"

    if [ "$num" -eq "0" ]
    then
        echo "Building " $name " ver " $ver " on branch " $branch " for target " $target
        build_target $branch $target $name $ver
	# Make newly built packages available as dependecies for the next ones
    #    ./update_repo

    fi

    num=$(find $repoDir/$branch -name "$name*" | grep -v SRPMS | wc | awk '{print $1}')
    if [ "$num" -eq "0" ]
    then
	echo "Package "$name" is not in the repository: please check!"
	exit
    fi
                                                                                    

}

echo "- Public repo is server from: "$repoDir
echo "- Source SRPMs are looked for into: "$rpmsrcDir
echo "- Build dir is: "$rpmbuildDir
echo "- Build will happen for branches: "$branches



