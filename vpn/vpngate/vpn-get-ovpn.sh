#4uto
vpn_lists=$(curl http://www.vpngate.net/api/iphone/ 2> /dev/null | awk -F',' '{print $1 "_" $7, $15}')
echo "${vpn_lists}" | while read line; do
  hostname=${line%% *}
  config=${line##* }
  echo $config | base64 -di > ${hostname}.ovpn 2> /dev/null
done

find . -type f ! \( -name "vpn*" -o -name "pass*" \) -delete 2> /dev/null
