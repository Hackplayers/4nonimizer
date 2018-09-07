#4uto
rm *.ovpn 2> /dev/null
wget -r -np -l 1 -A zip http://www.vpnbook.com/#openvpn --no-check-certificate 2> /dev/null
mv ./www.vpnbook.com/free-openvpn-account/*.zip . 
unzip \*.zip && rm *.zip && rm -rf ./www.vpnbook.com
