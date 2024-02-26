rm -f far2m_askpass
rm -f far2m_sudoapp
rm -f far2medit

ln -s far2m far2m_askpass
ln -s far2m far2m_sudoapp
ln -s far2m far2medit

chmod +x far2m
chmod +x far2m_sudoapp
chmod +x far2m_askpass
chmod +x far2medit

find . -type f -iname "*.broker" -exec chmod +x {} \;
find . -type f -iname "*.sh" -exec chmod +x {} \;

