#4uto
wget https://github.com/cryptostorm/cryptostorm_client_configuration_files/archive/master.zip 2> /dev/null
unzip -j master.zip 'cryptostorm_client_configuration_files-master/linux/*' && unzip -j master.zip 'cryptostorm_client_configuration_files-master/ca.crt' &&  rm master.zip
