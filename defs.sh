#!/bin/bash

SUCCESS=0

repoDir=/var/www/fedora/cil
rpmsrcDir=~/rpmbuild/SRPMS
rpmbuildDir=/var/lib/mock
suffix="-ralph-x86_64"

declare -a rpmdir=(x86_64 noarch SRPMS)
declare -a targets=(fedora-15$suffix fedora-14$suffix)
#declare -a targets=(fedora-15$suffix)

build_target() {
    target=$1
    name=$2
    ver=$3
        
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
    
    mock rebuild --no-clean -v -r $target $rpmsrcDir/$name$ver*.src.rpm
    
    if [ ! "$?" -eq $SUCCESS ]
    then
	echo "Can't build package "$name" retrying once..."
	mock rebuild --no-clean -v -r $target $rpmsrcDir/$name$ver*.src.rpm
	if [ ! "$?" -eq $SUCCESS ]
        then
	    echo "Can't build package "$name" please check!"
	    exit
	fi
    fi
    
    find $rpmbuildDir/$target/result/ -name "$name$ver*.src.rpm" -exec cp '{}' $repoDir/$target/SRPMS/ \;
    find $rpmbuildDir/$target/result/ -name "$name*.rpm" ! -name "*.src.rpm" -exec cp '{}' $repoDir/$target/x86_64/ \;

}

build_if_not_already() {
    target=$1
    name=$2
    ver=$3
    echo "Preparing package "$name$ver" for target "$target
    num=$(find $repoDir/$target -name "$name*" | wc | awk '{print $1}')
    echo "Found "$num" rpms for "$name" in repository"

    if [ "$num" -eq "0" ]
    then
        echo "Building " $name
        build_target $target $name $ver
	# Make newly built packages available as dependecies for the next ones
        ./update_repo
    fi

    num=$(find $repoDir/$target -name "$name*" | wc | awk '{print $1}')
    if [ "$num" -eq "0" ]
    then
	echo "Package "$name" is not in the repository: please check!"
	exit
    fi
                                                                                    

}

echo "- Public repo is server from: "$repoDir
echo "- Source SRPMs are looked for into: "$rpmsrcDir
echo "- Build dir is: "$rpmbuildDir
echo "- Build will happen for targets: "$targets



