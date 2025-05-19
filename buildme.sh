#!/bin/sh

KERNEL=6.12.0
MOCKROOT=oraclelinux-8-x86_64

if [ ! -d uek-rpm ]; then
	echo "please run in a linux-uek checkout on your expected branch"
	exit 1
fi

if [ ! -d uek-rpm/ol9 ]; then
	echo "please set $DIST to something that exists on this branch"
	exit 1
fi

mkdir -p ~/rpmbuild/{SOURCES,SPECS}

cp uek-rpm/ol9/* ~/rpmbuild/SOURCES
cp uek-rpm/tools/* ~/rpmbuild/SOURCES

mv ~/rpmbuild/SOURCES/kernel-uek.spec ~/rpmbuild/SPECS

rm -vf ~/rpmbuild/SOURCES/linux-${KERNEL}*
git archive --prefix=linux-${KERNEL}/ -o ~/rpmbuild/SOURCES/linux-${KERNEL}.tar HEAD
( cd ~/rpmbuild/SOURCES && bzip2 linux-${KERNEL}.tar )

rpmbuild --define 'dist .el9' --define 'buildid .local' -bs ~/rpmbuild/SPECS/kernel-uek.spec

echo Run \"mock -r ${MOCKROOT} --define \'buildid .local\' --rebuild '${SRPM}'\" on the .src.rpm from above.
