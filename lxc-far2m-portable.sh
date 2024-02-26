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
sudo lxc-attach -n far2m -- apt install -y wget
if [ -f "make_far2m_portable_on_ubuntu_16_04.sh" ]; then
  sudo cp make_far2m_portable_on_ubuntu_16_04.sh /var/lib/lxc/far2m/rootfs/
fi
if [ -f "autonomizer.sh" ]; then
  sudo cp autonomizer.sh /var/lib/lxc/far2m/rootfs/
fi
# if [ -f "tty_tweaks.patch" ]; then
#   sudo cp tty_tweaks.patch /var/lib/lxc/far2m/rootfs/
# fi
sudo lxc-attach -n far2m -- chmod +x make_far2m_portable_on_ubuntu_16_04.sh
sudo lxc-attach -n far2m -- ./make_far2m_portable_on_ubuntu_16_04.sh
sudo chmod +r -R /var/lib/lxc/far2m
sudo cp /var/lib/lxc/far2m/rootfs/root/far2m/far2m/build/far2m_portable.run .
sudo lxc-stop -n far2m
sudo lxc-destroy -n far2m
