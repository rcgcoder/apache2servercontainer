#!/bin/bash
#echo user passed $withUser - password $withPassword

export ENV_USER=${withUser:-sae}
export ENV_PASSWORD=${withPassword:-$ENV_USER}
export userPath="/home/$ENV_USER"
export ENV_MAIL=${withMail:-example@example.com}
export ENV_DOMAIN=${withDomain:-the.example.com}

echo $userPath -- $username
if [ ! -d "$userPath" ]; then
    echo "$userPath not exists";
	/usr/bin/addUserWithPassword $ENV_USER $ENV_PASSWORD
fi

certbot --apache --agree-tos -m $ENV_MAIL -d $ENV_DOMAIN -n


#export vncpasswdPath="$userPath/.vnc"
#if [ ! -d "$vncpasswdPath" ]; then
#    echo "$vncpasswdPath not exists";
#	mkdir -p $vncpasswdPath
#fi


