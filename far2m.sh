#!/bin/bash
pushd "$(pwd)"
cd "$(dirname "$0")"
chmod +x lib/ld-linux*
chmod +x far2m
chmod +x far2m_sudoapp
chmod +x far2m_askpass
find . -type f -iname "*far-plug*" -exec chmod +x {} \;
find . -type f -iname "*.broker" -exec chmod +x {} \;
./far2m
popd
