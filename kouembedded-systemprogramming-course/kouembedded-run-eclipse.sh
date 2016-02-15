#!/bin/bash

if [ "$USER_NAME" == "" ]; then
	USER_NAME=user
fi
USER_DIR=/home/$USER_NAME/.kouembedded-sistemprogramlama
SYSTEM_DIR=/opt/kouembedded-sistemprogramlama

if [ ! -f $SYSTEM_DIR/eclipse/eclipse ] || [ ! -d $USER_DIR/eclipse ] ; then
	gksudo "xterm -e kouembedded-reset-eclipse"
else
	/opt/kouembedded-sistemprogramlama/eclipse/eclipse -configuration $USER_DIR/eclipse
fi
