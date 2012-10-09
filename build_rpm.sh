#!/bin/bash

# Download source rpm from fedorapeople
# build it with mock on this machine for the given branch and arch
# create a local repo and populate with the results of the build
# Manually sync the local repo with the online one
 
branch=$1
arch=$2
pckg=$3

if [ -z "$branch" ]
then
	echo "Please specify branch"
	exit
fi
                    
if [ -z "$arch" ]
then
	echo "Please specify arch"
    exit
fi

if [ -z "$pckg" ]
then
	echo "Please specify SRPM name"
    exit
fi

echo "Building "$pckg" for "$branch"-"$arch
url="http://mrceresa.fedorapeople.org/"$pckg

wget $url

## Initialize buildroot
target=$branch"-ralph-"$arch
mock init -r $target

SUCCESS=0
mock rebuild --no-clean -v -r $target $pckg
    
if [ ! "$?" -eq $SUCCESS ]
then
	echo "Can't build package "$pckg" please check!"
	exit
fi

source defs.sh

find $rpmbuildDir/$target/result/ -name "$name$ver*.src.rpm" -exec cp '{}' $repoDir/$branch/SRPMS/ \;
find $rpmbuildDir/$target/result/ -name "$name*.rpm" ! -name "*.src.rpm" -exec cp '{}' $repoDir/$branch/x86_64/ \;




