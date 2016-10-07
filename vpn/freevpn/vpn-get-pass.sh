curl https://freevpn.me/accounts/ | egrep -Eio "Username:.*</li|Password:.*</li" | sort -u | head -1 | awk '{print $2"\n"$3}' | cut -d'<' -f1 > ./pass.txt
