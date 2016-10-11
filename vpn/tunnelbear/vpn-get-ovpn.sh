#4uto
rm *.ovpn 2> /dev/null
curl -O https://s3.amazonaws.com/tunnelbear/linux/openvpn.zip 2> /dev/null
unzip -j openvpn.zip
rm -rf openvpn.zip
