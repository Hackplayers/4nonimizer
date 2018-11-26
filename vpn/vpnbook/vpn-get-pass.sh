#!/bin/bash
#4uto
read -r -p "Would you like to attempt to automatically get credentials? [Y/n] " resp

tmpDir="/tmp/vpnPass/"
workDir="/opt/4nonimizer/vpn/vpnbook/"

case $resp in
	[yY][eE][sS]|[yY])
	userVar=$(curl https://www.vpnbook.com/freevpn 2> /dev/null | grep -E -m1 "Username" | awk '/Username/ {print $2;}' | sed -e 's/<[^>]*>//g')
	echo "Username: " $userVar
	echo $userVar > $workDir/pass.txt

	# Make our temporary work directory
	if [ ! -d $tmpDir ]; then
		mkdir $tmpDir
	fi
	if [ -d $tmpDir ]; then
		rm -rf $tmpDir
		mkdir $tmpDir
	fi

	#############
	# GET IMAGE #
	#############
	passLoc=$(curl https://www.vpnbook.com/freevpn 2> /dev/null | grep -E -m1 "Password" | awk '/Password/ {print $3;}' | sed 's/src="//g')
	$(wget -O $tmpDir/password.png https://www.vpnbook.com/$passLoc 2> /dev/null)

	$(convert $tmpDir/password.png $tmpDir/pass.tif &> /dev/null)
	$(tesseract $tmpDir/pass.tif $tmpDir/pass &> /dev/null)
	passText=$(cat $tmpDir/pass.txt)
	
	###############################
	# Check if missing characters #
	###############################
	if [[ $passText == *"?"* ]]; then
		echo "Extracted password: " $passText
		echo "Please reference this password: " $passText
		echo "With the Image I am opening"
		$(xdg-open $tmpDir/password.png &> /dev/null &)
		read -r -p "Please verify the missing character: " char 
		sed -i "s/?/$char/g" $tmpDir/pass.txt
		userPass=$(sed "s///g" $tmpDir/pass.txt)
		echo "New Password: " $userPass
		read -r -p "Is this correct? [y/N] " answer
		case $answer in
			[yY][eE][sS]|[yY])
			echo $userPass >> $workDir/pass.txt
				;;
			*)
				exit 1
				;;
		esac
	else
		echo $(sed "s///g" $tmpDir/pass.txt) >> $workDir/pass.txt
	fi
	sed -i 's///g' $workDir/pass.txt


############
# Clean Up #
############
rm -rf $tmpDir


###############
# Finish Case #
##############
	echo "Password updated!"
		;;
	*)
		exit 1
		;;
esac

#m4nual
#read -r -p "Visit https://www.vpnbook.com/#openvpn to get credentials. Do you want to continue [y/N] " response
#
#case $response in
#    [yY][eE][sS]|[yY]) 
#	read -p 'Username: ' uservar
#	stty -echo
#	read -p 'Password: ' passvar
#	stty echo
#	echo ""
#	echo $uservar > pass.txt && echo $passvar >> pass.txt
#        ;;
#    *)
#        exit 1
#        ;;
#esac
