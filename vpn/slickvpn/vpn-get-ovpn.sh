#4uto
for i in $(wget https://www.slickvpn.com/locations/ -q -O -); do 
	ovpnfile=$(echo "$i" | grep OpenVPN | cut -d '"' -f2) 
	if [ "$ovpnfile" ]; then
		wget $ovpnfile 2> /dev/null
	fi
done
