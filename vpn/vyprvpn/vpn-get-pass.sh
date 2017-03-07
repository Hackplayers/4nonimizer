#m4nual
read -r -p "Do you have a login for this vpn provider [y/N] " response

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

