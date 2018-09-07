#4uto
wget https://freevpn.me/FreeVPN.me-OpenVPN-Bundle.zip --no-check-certificate 2> /dev/null
unzip FreeVPN.me-OpenVPN-Bundle.zip && cd FreeVPN.me-OpenVPN-Bundle && find . -mindepth 2 -type f -print -exec mv {} ../ \;  && cd ../ && rm ./FreeVPN.me-OpenVPN-Bundle.zip && rm -r ./FreeVPN.me-OpenVPN-Bundle
