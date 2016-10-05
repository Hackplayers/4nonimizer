#!/bin/bash
curl www.vpnbook.com/#openvpn 2> /dev/null | grep -E "Username|Password" | awk '{print $2}' | cut -d'<' -f1 | sort -u > /opt/4nonimizer/vpn/vpnbook/pass.txt
