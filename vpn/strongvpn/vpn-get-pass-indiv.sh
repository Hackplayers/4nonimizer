#m4nual
echo "You must provide an individual login for this OpenVPN peer:"
read -p 'Username: ' uservar
stty echo
read -p 'Password: ' passvar
stty echo
echo $uservar > pass.txt && echo $passvar >> pass.txt
