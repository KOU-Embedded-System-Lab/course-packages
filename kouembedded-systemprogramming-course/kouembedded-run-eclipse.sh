#!/bin/bash

# UYARI: Eclipse eklentileri guncellemelerde sifirlanmaktadir.
# elle guncelleme kurulmak isteniliyorsa Eclipse kendi sitesinden indirilip kullanilmalidir.

if [ "$USER_NAME" == "" ]; then
	USER_NAME=user
fi

USER_DIR=/home/$USER_NAME/.kouembedded-systemprogramming
SYSTEM_DIR=/opt/kouembedded-systemprogramming
USER_ECLIPSE_DIR=$USER_DIR/eclipse
VERSION="20160217"

RUN_RESET=false

if [ "$VERSION" != "`cat $SYSTEM_DIR/version`" ]; then
	echo "Eclipse versiyonu farkli"
	RUN_RESET=true
fi

if [ ! -f $SYSTEM_DIR/eclipse/eclipse ]; then
	echo "Eclipse kurulu degil"
	RUN_RESET=true
fi

if [ ! -d $USER_ECLIPSE_DIR ]; then
	echo "Eclipse eklentileri ayarli degil"
	RUN_RESET=true
fi

if [ "$VERSION" != "`cat $USER_DIR/config_version`" ] ; then
	echo "Eclipse eklentileri guncel degil"
	RUN_RESET=true
fi

if [ $RUN_RESET == true ] ; then
	gksudo "xterm -e kouembedded-reset-eclipse"
else
	/opt/kouembedded-systemprogramming/eclipse/eclipse -configuration $USER_ECLIPSE_DIR/configuration
fi
