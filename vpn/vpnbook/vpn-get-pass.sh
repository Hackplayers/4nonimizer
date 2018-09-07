#m4nual
read -r -p "Visit https://www.vpnbook.com/#openvpn to get credentials. Do you want to continue [y/N] " response

case $response in
    [yY][eE][sS]|[yY]) 
	read -p 'Username: ' uservar
	stty -echo
	read -p 'Password: ' passvar
	stty echo
	echo ""
	echo $uservar > pass.txt && echo $passvar >> pass.txt
        ;;
    *)
        exit 1
        ;;
esac
