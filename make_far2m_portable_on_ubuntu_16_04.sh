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
apt-get install -y libneon27-dev
apt-get install -y libspdlog-dev patchelf wget gawk m4 libx11-dev libxi-dev libxerces-c-dev libuchardet-dev libnss-mdns libssh-dev libssl-dev libnfs-dev libarchive-dev libpcre3-dev cmake g++ git
# additional
apt-get install -y libluajit-5.1-dev luajit uuid-dev
git clone https://github.com/shmuz/far2m
cd far2m
# wget https://raw.githubusercontent.com/unxed/far2l-deb/master/portable/tty_tweaks.patch
# git apply tty_tweaks.patch
mkdir build
cd build
if [ "$gui_arg_present" = true ]; then
    cmake -DLEGACY=no -DCMAKE_BUILD_TYPE=Release ..
else
    cmake -DUSEWX=no -DLEGACY=no -DCMAKE_BUILD_TYPE=Release ..
fi
make -j$(nproc --all)
cd install
rm -rf far2m_askpass
echo "#!/bin/bash" > far2m_askpass
echo "cd \"\$FARHOME\"" >> far2m_askpass
echo "exec -a far2m_askpass ./far2m \$*" >> far2m_askpass
chmod +x far2m_askpass
# wget https://github.com/unxed/far2l-deb/raw/master/portable/far2l.sh
wget https://github.com/Zeroes1/far2m-portable/raw/main/far2m.sh
chmod +x far2m.sh
wget https://github.com/unxed/far2l-deb/raw/master/portable/autonomizer.sh
chmod +x autonomizer.sh
./autonomizer.sh
rm -rf autonomizer.sh
cd ..
mv install far2m_portable
git clone https://github.com/megastep/makeself.git
makeself/makeself.sh --keep-umask far2m_portable far2m_portable.run far2m ./far2m

