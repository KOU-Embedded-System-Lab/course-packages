
UPDATE_VERSION=...

echo "update $UDPATE_VERSION running"

sudo apt-get autoremove --purge catfish ristretto gucharmap xubuntu-community-wallpapers humanity-icon-theme language-pack-gnome-en-base language-pack-gnome-en
sudo apt-get autoremove --purge

echo $UPDATE_VERSION > /var/lib/kouembedded-xubuntu/version || exit 1
echo "update $UDPATE_VERSION completed"
exit 0
