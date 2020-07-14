#!/bin/bash
#echo user passed $withUser - password $withPassword

export ENV_USER=${withUser:-sae}
export ENV_PASSWORD=${withPassword:-$ENV_USER}
export userPath="/home/$ENV_USER"

echo $userPath -- $username
if [ ! -d "$userPath" ]; then
    echo "$userPath not exists";
	/usr/bin/addUserWithPassword $ENV_USER $ENV_PASSWORD
fi

certbot --apache  --agree-tos -m ricardo.cantabrana@gmail.com -d cantabrana.no-ip.org -n


#export vncpasswdPath="$userPath/.vnc"
#if [ ! -d "$vncpasswdPath" ]; then
#    echo "$vncpasswdPath not exists";
#	mkdir -p $vncpasswdPath
#fi


