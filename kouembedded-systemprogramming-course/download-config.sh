#!/bin/bash


if [ "$USER_NAME" == "" ]; then
	USER_NAME=user
fi

USER_DIR=/home/$USER_NAME/.kouembedded-systemprogramming
SYSTEM_DIR=/opt/kouembedded-systemprogramming
USER_ECLIPSE_DIR=$USER_DIR/eclipse
VERSION="20160217"

$SYSTEM_DIR/eclipse/eclipse \
	-configuration $USER_ECLIPSE_DIR/configuration \
	-clean -purgeHistory \
	-application org.eclipse.equinox.p2.director \
	-noSplash \
	-repository \
	http://gnuarmeclipse.sourceforge.net/updates,http://download.eclipse.org/releases/luna,http://download.eclipse.org/eclipse/updates/4.4 \
	\
	-installIUs ilg.gnuarmeclipse.managedbuild.cross.feature.group,ilg.gnuarmeclipse.debug.gdbjtag.openocd.feature.group,ilg.gnuarmeclipse.templates.cortexm.feature.group \
	\
	-vmargs -Declipse.p2.mirrors=true -Djava.net.preferIPv4Stack=true


echo $VERSION > $USER_DIR/config_version


echo "run Eclipse and install configuration"


#,ilg.gnuarmeclipse.templates.stm.feature.group
