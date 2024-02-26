#!/bin/bash
# Check if the argument "--gui" is present
gui_arg_present=false
for arg in "$@"
do
  if [ "$arg" == "--gui" ]; then
    gui_arg_present=true
    break
  fi
done
#
mkdir ~
cd ~
rm -rf far2m
mkdir far2m
cd far2m
apt-get update

if [ "$gui_arg_present" = true ]; then
    sudo apt install -y libwxgtk3.0-dev    
    sudo apt install -y libwxgtk3.0-gtk3-dev
    sudo apt install -y libwxgtk3.2-dev
    sudo apt install -y libsmbclient-dev
fi

apt-get install -y libspdlog-dev patchelf wget gawk m4 libx11-dev libxi-dev libxerces-c-dev libuchardet-dev libssh-dev libssl-dev libnfs-dev libneon27-dev libarchive-dev libpcre3-dev cmake g++ git
apt-get install -y libluajit-5.1-dev uuid-dev
git clone https://github.com/shmuz/far2m
cd far2m
# if [ -f "/tty_tweaks.patch" ]; then
#   cp /tty_tweaks.patch .
# else
#   wget https://raw.githubusercontent.com/unxed/far2l-deb/master/portable/tty_tweaks.patch
# fi
# git apply tty_tweaks.patch
mkdir build
cd build
if [ "$gui_arg_present" = true ]; then
    cmake -DUSEWX=yes -DNETCFG=no -DCMAKE_BUILD_TYPE=Release ..
else
    cmake -DUSEWX=no  -DNETCFG=no -DCMAKE_BUILD_TYPE=Release ..
fi
make -j$(nproc --all)
cd install
rm -rf ./lib
mkdir lib
# if [ -f "./Plugins/luafar/luafar.so" ]; then
#   mv ./Plugins/luafar/luafar.so ./lib/luafar.so
# fi
if [ -f "/usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2.0.4" ]; then
  cp /usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2.0.4 ./lib/libluajit-5.1.so
fi
if [ -f "/autonomizer.sh" ]; then
  cp /autonomizer.sh .
fi
chmod +x autonomizer.sh
./autonomizer.sh
rm -f autonomizer.sh
rm lib/libc.so.6
rm lib/libdl.so.2
rm lib/libgcc_s.so.1
rm lib/libm.so.6
rm lib/libpthread.so.0
rm lib/libstdc++.so.6
rm lib/libresolv.so.2
rm lib/librt.so.1
cd ..
mv install far2m_portable
git clone https://github.com/megastep/makeself.git
makeself/makeself.sh far2m_portable far2m_portable.run far2m ./far2m
