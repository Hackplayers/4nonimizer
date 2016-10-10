curl https://freevpn.me/accounts/ |  egrep -Eio "Username.*?</li><li><b>Unlimited</b>" | awk '{print $17"\n"$18}' | cut -d'<' -f1 > ./pass.txt
