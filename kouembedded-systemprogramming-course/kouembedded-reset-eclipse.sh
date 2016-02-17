#!/bin/bash

if [ "$USER_NAME" == "" ]; then
	USER_NAME=user
fi

USER_DIR=/home/$USER_NAME/.kouembedded-systemprogramming
SYSTEM_DIR=/opt/kouembedded-systemprogramming
USER_ECLIPSE_DIR=$USER_DIR/eclipse
VERSION="20160217"

TMP_DIR=/tmp/$$

clean_exit() {
	rm -rf $TMP_DIR
}

trap "clean_exit" SIGTERM EXIT


exit_error() {
	echo "islem sirasinda hata olustu"
	echo "programi kapatip tekrar deneyin"
	read
	exit 1
}

clean-config() {
	rm -rf $USER_ECLIPSE_DIR
}

install-config() {

	if [ ! -f $USER_DIR/kouembedded-systemprogramming-conf-$VERSION.tar.xz ]; then
		rm -rf $USER_DIR/kouembedded-systemprogramming-conf-*.tar.xz
		echo "Sistem Programlama dersi icin Eclipse ayarlari indiriliyor"
		aria2c -d $USER_DIR -x4 https://github.com/KOU-Embedded-System-Lab/course-packages/releases/download/$VERSION/kouembedded-systemprogramming-conf-$VERSION.tar.xz
	fi

	mkdir -p $TMP_DIR
	tar xf $USER_DIR/kouembedded-systemprogramming-conf-$VERSION.tar.xz -C $TMP_DIR/

	echo "Eclipse ayarlari kuruluyor"
	rm -rf $USER_ECLIPSE_DIR
	mv $TMP_DIR/eclipse $USER_ECLIPSE_DIR

	echo $VERSION > $USER_DIR/config_version

}

clean-all() {
	clean-config
	rm -rf $SYSTEM_DIR

	if [ "$1" == "full" ] || [ -f $USER_DIR/download_not_completed ]; then
		echo "Eski kurulum tamamen siliniyor"
		rm -rf $USER_DIR
	fi
}


install-all() {
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

	echo "$VERSION" > $SYSTEM_DIR/version

	echo
	install-config
	chown -R $USER_NAME:$USER_NAME $USER_ECLIPSE_DIR
}

echo "Eclipse guncelleniyor. Pencereyi kapatmayin."
echo "UYARI: Islem internet baglantisi kullanmaktadir."
echo


if [ `id -u` == 0 ]; then
	echo ">> Eclipse Sistem Kurulumu"
	clean-all
	install-all
else
	echo ">> Eclipse Ayar Sifirlama"
	clean-config
	install-config
fi


echo -e "\nIslem tamamlandi. Pencereyi kapatip programi calistirabilirsiniz."
read
