#!/bin/bash

get_package_version() {
	local NAME=$1
	local VERSION=`cat $NAME/debian/changelog | grep $NAME | head -n 1 | awk {'print $2'}`
	local VERSION=${VERSION:1:-1}
	echo $VERSION
}

build() {
	local PACKAGE_NAME=$1
	[ -d "$PACKAGE_NAME" ] || print_usage_exit

	local VERSION=`get_package_version $PACKAGE_NAME`

	rm -rf tmp/
	mkdir tmp/
	echo "copy $PACKAGE_NAME -> tmp/$PACKAGE_NAME"
	cp -rf ${PACKAGE_NAME} tmp/${PACKAGE_NAME}

	echo "rm *~ in tmp/${PACKAGE_NAME}"
	find tmp/${PACKAGE_NAME} -name "*~" -exec rm -f "{}" \;

	cd tmp/
	echo "creating tmp/$PACKAGE_NAME-$VERSION.orig.tar.gz"
	mv ${PACKAGE_NAME}/debian ${PACKAGE_NAME}_debian_$$
	tar czf ${PACKAGE_NAME}_${VERSION}.orig.tar.gz ${PACKAGE_NAME}
	mv ${PACKAGE_NAME}_debian_$$ ${PACKAGE_NAME}/debian
	echo

	cd ${PACKAGE_NAME}/
	if [ "$2" == "bin" ]; then
		debuild -us -uc
	else
		debuild -us -uc -S -sa
	fi
}

upload-ppa() {
	local PACKAGE_NAME=$1
	local DEBSIGN_KEYID=$2
	local DPUT_HOST=$3
	[ -d "$PACKAGE_NAME" ] || print_usage_exit
	[ "$DEBSIGN_KEYID" != "" ] || print_usage_exit
	[ "$DPUT_HOST" != "" ] || print_usage_exit

	local VERSION=`get_package_version $PACKAGE_NAME`

	if [ ! -f tmp/${PACKAGE_NAME}_${VERSION}_source.changes ]; then
		echo "build first"
		exit
	fi
	debsign -k $DEBSIGN_KEYID tmp/${PACKAGE_NAME}_${VERSION}_source.changes
	dput $DPUT_HOST tmp/${PACKAGE_NAME}_${VERSION}_source.changes
}

print_usage_exit() {
	echo "usage:"
	echo "	$0 build PACKAGE_NAME [bin]"
	echo "	$0 upload-ppa PACKAGE_NAME DEBSIGN_KEYID DPUT_HOST"
	exit
}

COMMAND=$1
[ "$COMMAND" == "build" ] && build $2 $3
[ "$COMMAND" == "upload-ppa" ] && upload-ppa $2 $3 $4
[ "$COMMAND" == "help" ] && print_usage_exit
