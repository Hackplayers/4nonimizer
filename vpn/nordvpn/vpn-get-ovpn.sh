#4uto
rm *.ovpn 2> /dev/null
#wget https://nordvpn.com/api/static/ca_and_tls_auth_certificates.zip
wget https://nordvpn.com/api/files/zip
unzip \*zip && rm *zip
