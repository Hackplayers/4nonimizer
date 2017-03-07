#4uto
rm *.ovpn 2> /dev/null
wget https://www.goldenfrog.com/openvpn/VyprVPNOpenVPNFiles.zip 2> /dev/null
unzip VyprVPNOpenVPNFiles.zip
cd GFVyprVPNOpenVPNFiles/VyprVPNOpenVPNFiles/OpenVPN256 && mv ./* ../../..
cd ../../.. && rm ./VyprVPNOpenVPNFiles.zip && rm -r ./GFVyprVPNOpenVPNFiles
