#!/bin/bash

COMMAND=$1
PACKAGE_NAME=$2

[ "$PACKAGE_NAME" != "" ] || exit 1

VERSION=`cat $PACKAGE_NAME/debian/changelog | grep $PACKAGE_NAME | head -n 1 | awk {'print $2'}`
VERSION=${VERSION:1:-1}

echo "package name: $PACKAGE_NAME"
echo "package version: $VERSION"


build() {
	mkdir tmp/

	echo "copy $PACKAGE_NAME -> tmp/$PACKAGE_NAME"
	cp -rf ${PACKAGE_NAME} tmp/${PACKAGE_NAME}

	echo "rm *~ in tmp/${PACKAGE_NAME}"
	find tmp/${PACKAGE_NAME} -name "*~" -exec rm -f "{}" \;

	cd tmp/
	echo "creating tmp/$PACKAGE_NAME-$VERSION.orig.tar.gz"
	tar czf ${PACKAGE_NAME}_${VERSION}.orig.tar.gz ${PACKAGE_NAME}
	echo

	cd ${PACKAGE_NAME}/
	if [ "$1" == "bin" ]; then
		debuild -us -uc
	else
		debuild -us -uc -S -sa
	fi
}

upload-ppa() {
	if [ ! -f tmp/${PACKAGE_NAME}_${VERSION}_source.changes ]; then
		echo "build first"
		exit
	fi
	debsign -k $1 tmp/${PACKAGE_NAME}_${VERSION}_source.changes
	dput $2 tmp/${PACKAGE_NAME}_${VERSION}_source.changes
}

[ "$COMMAND" == "build" ] && build $3
[ "$COMMAND" == "upload-ppa" ] && upload-ppa $3 $4

