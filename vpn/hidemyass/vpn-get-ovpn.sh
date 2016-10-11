#4uto
rm *.ovpn 2> /dev/null
wget https://www.hidemyass.com/vpn-config/vpn-configs.zip 2> /dev/null
unzip vpn-configs.zip
mv TCP/* .
mv UDP/* .
rm -rf TCP UDP
rm vpn-configs.zip
