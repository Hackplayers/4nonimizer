#4uto
rm *.ovpn 2> /dev/null
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip openvpn.zip
rm openvpn.zip
for f in *\ *; do mv "$f" "${f// /_}"; done
