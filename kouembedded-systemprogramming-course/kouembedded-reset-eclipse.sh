#!/bin/bash

exit_error() {
	echo "islem sirasinda hata olustu"
	echo "programi kapatip tekrar deneyin"
	read
	exit 1
}

echo "Eclipse ayarlaniyor. Pencereyi kapatmayin."
echo "UYARI: Islem internet baglantisi kullanmaktadir."
echo

if [ "$USER_NAME" == "" ]; then
	USER_NAME=user
fi

USER_DIR=/home/$USER_NAME/.kouembedded-sistemprogramlama
SYSTEM_DIR=/opt/kouembedded-sistemprogramlama


rm -rf $SYSTEM_DIR
rm -rf $USER_DIR/eclipse

if [ "$1" == "full" ] || [ -f $USER_DIR/download_not_completed ]; then
	echo "Eski kurulum tamamen siliniyor"
	rm -rf $USER_DIR
fi

mkdir -p $SYSTEM_DIR
mkdir -p $USER_DIR

if [ ! -f $USER_DIR/eclipse-luna.tar.xz ]; then
	echo "Eclipse indiriliyor"
	touch $USER_DIR/download_not_completed
	aria2c -d $USER_DIR -o eclipse-luna.tar.xz -x4 http://ftp.fau.de/eclipse/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk.tar.gz
	rm -f $USER_DIR/download_not_completed
else
	echo "Daha onceden indirilmis kurulum dosyasi bulundu"
fi

echo "Eclipse kuruluyor"
tar xf $USER_DIR/eclipse-luna.tar.xz -C $SYSTEM_DIR || exit_error

echo
echo "Eklentiler indiriliyor ve kuruluyor"
echo "Not: Bu islem 5 dakika civari surebilir"

$SYSTEM_DIR/eclipse/eclipse -configuration $USER_DIR/eclipse \
-clean -purgeHistory \
-application org.eclipse.equinox.p2.director \
-noSplash \
-repository \
http://gnuarmeclipse.sourceforge.net/updates,\
http://download.eclipse.org/releases/luna,\
http://download.eclipse.org/eclipse/updates/4.4 \
\
-installIUs \
ilg.gnuarmeclipse.managedbuild.cross.feature.group,\
ilg.gnuarmeclipse.debug.gdbjtag.openocd.feature.group,\
ilg.gnuarmeclipse.templates.cortexm.feature.group,\
ilg.gnuarmeclipse.templates.stm.feature.group \
\
-vmargs -Declipse.p2.mirrors=true -Djava.net.preferIPv4Stack=true 2&> $USER_DIR/kouembedded-reset-eclipse.log || exit_error

chown -R $USER_NAME:$USER_NAME $USER_DIR/

echo -e "\nIslem tamamlandi. Pencereyi kapatip programi calistirabilirsiniz."
read
