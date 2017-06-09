#4uto
echo "vpnbook" > /opt/4nonimizer/vpn/vpnbook/pass.txt
curl https://www.vpnbook.com/#openvpn 2> /dev/null | grep -E "Password" | awk '{print $2}' | cut -d'<' -f1 | sort -u >> /opt/4nonimizer/vpn/vpnbook/pass.txt
