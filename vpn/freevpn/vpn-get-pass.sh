#4uto
curl https://freevpn.me/accounts/ 2> /dev/null | egrep -Eio ">OpenVPN</h3>.*" | egrep -Eio "Username.*?</li><li><b>Unlimited</b>" | awk '{print $2"\n"$3}' | cut -d'<' -f1 > pass.txt
