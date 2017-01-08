#!/bin/bash
###########################################################################################
# Last update version 1.05								  #
# Authors: Carlos Antonini & Vicente Motos						  #
# Description: this lib contains location of vpn peers					  #
# 											  #
###########################################################################################


function rename_ovpns_for_location () {
			
			num=0
			array1=()
			
			RENAMEDFILES=$(ls /opt/4nonimizer/vpn/$provider/*renamed.ovpn 2> /dev/null | wc -l)
		
			if [ "$RENAMEDFILES" = "0" ] ; then
			
				echo -e "\n${RED}[*] Wait until the program finishes calculating the available countries and renaming files: ${NC}\n"

				for lista in $(ls /opt/4nonimizer/vpn/$provider/*.ovpn);
				do
					num=`expr $num + 1`
					ip=`cat $lista | grep remote | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v '#'`
					if [ -z "$ip" ]; then
						ip=`cat $lista | grep -m 1 "remote " | grep -v '#' | awk {'print $2'}`
						ip=$(dig +short $ip | shuf -n 1 | awk '{ print ; exit }')
					fi
					codecountry=$(whois $ip | awk -F':[ \t]+' 'tolower($1) ~ /^country$/ { print toupper($2) ;exit;}')
					country=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$codecountry -F $'\t' '$1 == r' | awk  -F $'\t' '{print $5}'| tr -d '[:space:]')
					
					if [ -z "$country" ] ; then country="unknown"; fi
			
					array1+=($country)
					
					mv "$lista" "${lista/\.ovpn/\-$country\-renamed\.ovpn}"
					PAISES[$num]="${lista/\.ovpn/\-$country\-renamed\.ovpn}"
					echo "${lista/\.ovpn/\-$country\-renamed\.ovpn}"			
				done
				
				echo -en "${RED}Done! ${NC}\n\n"

			else
			
				echo -e "\n${RED}[*] The ovpn files have already been renamed before. ${NC}\n"
		
			fi
}

function locate_offline () {
			
                        echo -en "\n\nNumber > "
                        read new
			
			if [[ " ${rangonumcont[@]} " =~ " ${new} " ]]; then
				echo "estas seleccionando continente ${CONT[$new]}"
				continentname=${CONT[$new]}
				if [[ "$continentname" == "unknown" ]]; then
					/opt/4nonimizer/4nonimizer change_ip
					break
				fi
				tocontinentcode
				#echo -e "\n$continentcode"
				for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'_' '{print $2}' | cut -d'.' -f1 | sort -u);
                                do
					continentcode2=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$1 == r' | awk  -F $'\t' '{print $9}')

					if [[ "$continentcode" == "$continentcode2" ]] ; then 
						array2+=($lista)
					fi
	
				done	
				
			#echo "${array2[@]}"
			countryselected=$(for el in "${array2[@]}"; do echo $el; done | shuf | head -1)
			#echo $countryselected && sleep 10
			SELECTOVPN=$(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | grep $countryselected | shuf -n 1)
			echo -e "\n\n${RED}[*] 4nonimizer is going to use the $SELECTOVPN file. ${NC}\n"
			sleep 3
			restart
				
			else
			echo "You've selected to use a specific country"
			countryselected=${PAISES[$new]} 
			if [[ "$countryselected" == "unknown" ]]; then
				/opt/4nonimizer/4nonimizer change_ip
				break
			fi
			#echo ${PAISES[$new]} 						
			#cd /opt/4nonimizer/vpn/$provider/ ; openvpn "$(ls *.ovpn | grep ${PAISES[$new]} | shuf -n 1)"
	
			SELECTOVPN=$(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | grep ${PAISES[$new]} | shuf -n 1)
			echo -e "\n\n${RED}[*] 4nonimizer is going to use the $SELECTOVPN file. ${NC}\n"
			sleep 3
			restart

			fi
}

function locate_online () {
			
			rename_ovpns_for_location
			
			num=0
			echo -e "\n${RED}[*] Please, select the country from which you want to connect: ${NC}\n"
                        for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'-' '{print $(NF-1)}' | cut -d'.' -f1 | sort -u);
                                do
                                num=`expr $num + 1`
				if [ -z "$lista" ] ; then country="unknown"; fi
                                echo  -ne "   ["$num"]-"$lista
                                PAISES[$num]=$lista
			done
			
			array=()
			echo -e "\n\n${RED}[*] or if you prefer select the continent: ${NC}\n"
			 for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'-' '{print $(NF-1)}' | cut -d'.' -f1 | sort -u);
                                do
				continentcode=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$5 == r' | awk  -F $'\t' '{print $9}')
				tocontinentname
			        if [ -z "$continent" ] ; then country="unknown"; fi
				array+=($continent)
			done	


			sorted_unique_continents=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

							
			 for i in ${sorted_unique_continents[@]}
			 do 
				num=`expr $num + 1`
				echo  -ne "   ["$num"]-"$i
				rangonumcont+=($num)
				CONT[$num]=$i

			done
			
		                        echo -en "\n\nNumber > "
                        read new
			
			if [[ " ${rangonumcont[@]} " =~ " ${new} " ]]; then
				echo "estas seleccionando continente ${CONT[$new]}"
				continentname=${CONT[$new]}
				if [[ "$continentname" == "unknown" ]]; then
					/opt/4nonimizer/4nonimizer change_ip
					break
				fi
				tocontinentcode
				for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'-' '{print $(NF-1)}' | cut -d'.' -f1 | sort -u);
                                do
					continentcode2=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$5 == r' | awk  -F $'\t' '{print $9}')

					if [[ "$continentcode" == "$continentcode2" ]] ; then
						array2+=($lista)
					fi
	
				done	
				

			#echo "${array2[@]}"
			countryselected=$(for el in "${array2[@]}"; do echo $el; done | shuf | head -1)

			SELECTOVPN=$(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | grep $countryselected | shuf -n 1)
			echo -e "\n\n${RED}[*] 4nonimizer is going to use the $SELECTOVPN file. ${NC}\n"
			sleep 3
			restart
				
			else
			echo "You've selected to use a specific country"
			#echo ${PAISES[$new]} 						
			#cd /opt/4nonimizer/vpn/$provider/ ; openvpn "$(ls *.ovpn | grep ${PAISES[$new]} | shuf -n 1)"
			countryselected=${PAISES[$new]} 
			if [[ "$countryselected" == "unknown" ]]; then
				/opt/4nonimizer/4nonimizer change_ip
				break
			fi
			SELECTOVPN=$(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | grep ${PAISES[$new]} | shuf -n 1)
			echo -e "\n\n${RED}[*] 4nonimizer is going to use the $SELECTOVPN file. ${NC}\n"
			sleep 3
			restart

			fi

}

function location () {
	asciilogo
	checkifinstalled
	provider=$(cat /opt/4nonimizer/4nonimizer | awk 'NR==73' | awk -F';' '{print $1}' | awk -F'/' '{print $5}')
	echo -e "\nVPN Provider: \t $provider\n"

	case $provider  in
                freevpn)
			locate_online
                ;;
                hidemyass)
		
		num=0
			echo -e "\n${RED}[*] Please, select the country from which you want to connect: ${NC}\n"
                        for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'.' '{print $1}' | sort -u);
                                do
                                num=`expr $num + 1`
				country=$lista
			        if [ -z "$country" ] ; then country="unknown"; fi
                                echo  -ne "   ["$num"]-"$country
                                PAISES[$num]=$lista
			done
			
			array=()
			echo -e "\n\n${RED}[*] or if you prefer select the continent: ${NC}\n"
			 for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'.' '{print $1}' | sort -u);
                                do
				continentcode=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$5 == r' | awk  -F $'\t' '{print $9}')
				tocontinentname
			        if [ -z "$continent" ] ; then country="unknown"; fi
				array+=($continent)
			done	


			sorted_unique_continents=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

							
			 for i in ${sorted_unique_continents[@]}
			 do 
				num=`expr $num + 1`
				echo  -ne "   ["$num"]-"$i
				rangonumcont+=($num)
				CONT[$num]=$i

			done
			
		locate_offline
		
     		;;            
                torguard)
			locate_online
                ;;
		tunnelbear)
		       num=0
			echo -e "\n${RED}[*] Please, select the country from which you want to connect: ${NC}\n"
                        for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F' ' '{print $2}' | cut -d'.' -f1 | sort -u);
                                do
                                num=`expr $num + 1`
				country=$lista
			        if [ -z "$country" ] ; then country="unknown"; fi
                                echo  -ne "   ["$num"]-"$country
                                PAISES[$num]=$lista
			done
			
			array=()
			echo -e "\n\n${RED}[*] or if you prefer select the continent: ${NC}\n"
			 for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F' ' '{print $2}' | cut -d'.' -f1 | sort -u);
                                do
				continentcode=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$5 == r' | awk  -F $'\t' '{print $9}')
				tocontinentname
			        if [ -z "$continent" ] ; then country="unknown"; fi
				array+=($continent)
			done	


			sorted_unique_continents=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

							
			 for i in ${sorted_unique_continents[@]}
			 do 
				num=`expr $num + 1`
				echo  -ne "   ["$num"]-"$i
				rangonumcont+=($num)
				CONT[$num]=$i

			done
			
		locate_offline
		;;
		vpnbook)
		
		locate_online
		;;
		vpngate)
		
		num=0
			echo -e "\n${RED}[*] Please, select the country from which you want to connect: ${NC}\n"
                        for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'_' '{print $2}' | cut -d'.' -f1 | sort -u);
                                do
                                num=`expr $num + 1`
				country=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$1 == r' | awk  -F $'\t' '{print $5}')
			        if [ -z "$country" ] ; then country="unknown"; fi
                                echo  -ne "   ["$num"]-"$country
                                PAISES[$num]=$lista
			done
			
			array=()
			echo -e "\n\n${RED}[*] or if you prefer select the continent: ${NC}\n"
			 for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F'_' '{print $2}' | cut -d'.' -f1 | sort -u);
                                do
				continentcode=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$1 == r' | awk  -F $'\t' '{print $9}')
				tocontinentname
			        if [ -z "$continent" ] ; then country="unknown"; fi
				array+=($continent)
			done	


			sorted_unique_continents=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

							
			 for i in ${sorted_unique_continents[@]}
			 do 
				num=`expr $num + 1`
				echo  -ne "   ["$num"]-"$i
				rangonumcont+=($num)
				CONT[$num]=$i

			done
			
		locate_offline
		
		;;
		vpnkeys)
		locate_online
		;;
		vpnme)
		locate_online	
		;;
		cryptostorm)
		locate_online
		;;
		pia)
			array_pais=()
			echo -e "\n${RED}[*] Please, select the country from which you want to connect: ${NC}\n"
                        for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F' ' '{print $1}' | cut -d'.' -f1 | sort -u);
                                do
                                num=`expr $num + 1`
				if [[ $lista == *"UK_"* ]]
				then
				  lista="UnitedKingdom";
				fi
				if [[ $lista == *"US_"* ]]
				then
				  lista="UnitedStates";
				fi
				if [[ $lista == *"CA_"* ]]
				then
				  lista="Canada";
				fi
				if [[ $lista == *"AU_"* ]]
				then
				  lista="Australia";
				fi
				if [ -z "$lista" ] ; then lista="unknown"; fi
				array_pais+=($lista)
			done

			sorted_unique_countries=$(echo "${array_pais[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

			num=0				
			 for i in ${sorted_unique_countries[@]}
			 do 
				num=`expr $num + 1`
				echo  -ne "   ["$num"]-"$i
				rangonumcont_country+=($num)
				COUN[$num]=$i

			done
			
			array=()
			echo -e "\n\n${RED}[*] or if you prefer select the continent: ${NC}\n"
			 for lista in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | awk -F' ' '{print $1}' | cut -d'.' -f1 | sort -u);
                                do
				if [[ $lista == *"UK_"* ]]
				then
				  lista="UnitedKingdom";
				fi
				if [[ $lista == *"US_"* ]]
				then
				  lista="UnitedStates";
				fi
				if [[ $lista == *"CA_"* ]]
				then
				  lista="Canada";
				fi
				if [[ $lista == *"AU_"* ]]
				then
				  lista="Australia";
				fi
				continentcode=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$lista -F $'\t' '$5 == r' | awk  -F $'\t' '{print $9}')
				tocontinentname
			        if [ -z "$continent" ] ; then country="unknown"; fi
				array+=($continent)
			done	

			sorted_unique_continents=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

							
			 for i in ${sorted_unique_continents[@]}
			 do 	
				num=`expr $num + 1`
				echo  -ne "   ["$num"]-"$i
				rangonumcont+=($num)
				CONT[$num]=$i

			done


 			echo -en "\n\nNumber > "
                        read new
			
			if [[ " ${rangonumcont[@]} " =~ " ${new} " ]]; then
				echo "estas seleccionando continente ${CONT[$new]}"
				continentselected=${CONT[$new]}
				for file in $(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn);
                                do	

					country=$(cd /opt/4nonimizer/vpn/$provider/; ls $file | awk -F'_' '{print $1}' | cut -d'.' -f1)

					if [[ $country == *"UK"* ]]
					then
					  country="UnitedKingdom";
					fi
					if [[ $country == *"US"* ]]
					then
					  country="UnitedStates";
					fi
					if [[ $country == *"CA"* ]]
					then
					  country="Canada";
					fi
					if [[ $country == *"AU"* ]]
					then
					  country="Australia";
					fi

					continentcode=$(cat /opt/4nonimizer/countryInfo.txt | awk -v r=$country -F $'\t' '$5 == r' | awk  -F $'\t' '{print $9}')
					tocontinentname
	
					#echo $file $country $continentcode $continent
					if [ "$continent" == "$continentselected" ]; then
						SELECTOVPN=$file
						break
					fi
				done

				echo -e "\n\n${RED}[*] 4nonimizer is going to use the $SELECTOVPN file. ${NC}\n"
				sleep 3
				restart
				
			else
			echo "You've selected to use the specific country ${COUN[$new]}"
			countryselected=${COUN[$new]} 
			if [[ "$countryselected" == "unknown" ]]; then
				/opt/4nonimizer/4nonimizer change_ip
				break
			fi

			if [[ $countryselected == *"UnitedKingdom"* ]]
				then
				  countryselected="UK_";
				fi
				if [[ $countryselected == *"UnitedStates"* ]]
				then
				  countryselected="US_";
				fi
				if [[ $countryselected == *"Canada"* ]]
				then
				  countryselected="CA_";
				fi
				if [[ $countryselected == *"Australia"* ]]
				then
				  countryselected="AU_";
				fi
	
			SELECTOVPN=$(cd /opt/4nonimizer/vpn/$provider/; ls *.ovpn | grep $countryselected | shuf -n 1)
			echo -e "\n\n${RED}[*] 4nonimizer is going to use the $SELECTOVPN file. ${NC}\n"
			sleep 3
			restart

			fi
			
		;;
                *)
			echo -e "Error!!"
		;;              
          esac 
}

tocontinentname(){

case $continentcode in
    "AF" )    continent="Africa"; ;; 
    "AN" )    continent="Antarctica"; ;; 
    "AS" )    continent="Asia"; ;; 
    "OC" )    continent="Australia(Oceania)"; ;; 
    "EU" )    continent="Europe"; ;; 
    "NA" )    continent="NorthAmerica"; ;; 
    "SA" )    continent="SouthAmerica"; ;; 
    * )      continent="unknown"; ;; 
esac
	
}

tocontinentcode(){

case $continentname in
    "Africa" )    continentcode="AF"; ;; 
    "Antarctica" )    continentcode="AN"; ;; 
    "Asia" )    continentcode="AS"; ;; 
    "Australia(Oceania)" )    continentcode="OC"; ;; 
    "Europe" )    continentcode="EU"; ;; 
    "NorthAmerica" )    continentcode="NA"; ;; 
    "SouthAmerica" )    continentcode="SA"; ;; 
    * )      continentcode="unknown"; ;; 
esac
	

