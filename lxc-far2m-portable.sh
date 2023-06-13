#!/bin/bash
sudo apt install -y lxc
# cleanup
sudo lxc-stop -n far2m
sudo lxc-destroy -n far2m
sudo rm -rf ~/far2m_portable.run
# here we go
sudo lxc-create -t download -n far2m -- --force-cache -d ubuntu -r xenial -a amd64
sudo lxc-start -n far2m -d
sleep 2
sudo lxc-attach -n far2m -- dhclient eth0
echo nameserver 1.1.1.1 | sudo lxc-attach -n far2m -- tee /run/resolvconf/resolv.conf
sudo lxc-attach -n far2m -- sudo apt install -y wget
# sudo lxc-attach -n far2m -- wget https://github.com/unxed/far2m-deb/raw/master/portable/make_far2m_portable_on_ubuntu_16_04.sh
# sudo lxc-attach -n far2m -- wget https://raw.githubusercontent.com/Zeroes1/far2m-portable/master/make_far2m_portable_on_ubuntu_16_04.sh
sudo lxc-attach -n far2m -- wget https://github.com/Zeroes1/far2m-portable/raw/main/make_far2m_portable_on_ubuntu_16_04.sh
sudo lxc-attach -n far2m -- chmod +x make_far2m_portable_on_ubuntu_16_04.sh
sudo lxc-attach -n far2m -- ./make_far2m_portable_on_ubuntu_16_04.sh "$@"
sudo chmod +r -R /var/lib/lxc/far2m
sudo cp /var/lib/lxc/far2m/rootfs/root/far2m/far2m/build/far2m_portable.run .
sudo lxc-stop -n far2m
sudo lxc-destroy -n far2m
