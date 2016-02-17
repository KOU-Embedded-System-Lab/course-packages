
UPDATE_VERSION=v20160217

echo "update $UDPATE_VERSION running"

echo "deb ftp://ftp.uni-kl.de/pub/linux/ubuntu/ trusty main restricted universe multiverse
deb ftp://ftp.uni-kl.de/pub/linux/ubuntu/ trusty-security main restricted universe multiverse
deb ftp://ftp.uni-kl.de/pub/linux/ubuntu/ trusty-updates main restricted universe multiverse
deb ftp://ftp.uni-kl.de/pub/linux/ubuntu/ trusty-backports main restricted universe multiverse" > /etc/apt/sources.list || exit 1

usermod -a -G dialout user || exit 1

mkdir -p /var/lib/kouembedded-xubuntu
echo $UPDATE_VERSION > /var/lib/kouembedded-xubuntu/version || exit 1

echo "update $UDPATE_VERSION completed"
exit 0
