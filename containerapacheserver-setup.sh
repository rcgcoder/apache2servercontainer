#!/bin/bash

echo running containerapacherserver-setup.sh....

echo user passed $withUser - password $withPassword - mail $withMail - domain $withDomain - secret $withSecretCertificate

export ENV_USER=${withUser:-sae}
export ENV_PASSWORD=${withPassword:-$ENV_USER}
export userPath="/home/$ENV_USER"
export ENV_MAIL=${withMail:-example@example.com}
export ENV_DOMAIN=${withDomain:-the.example.com}
export ENV_TESTING=${withTestingCertificate:-true}
export ENV_SECRET_CERT=${withSecretCertificate:-false}


echo $userPath -- $username
if [ ! -d "$userPath" ]; then
    echo "$userPath not exists";
	/usr/bin/addUserWithPassword $ENV_USER $ENV_PASSWORD
fi


echo mail $withMail - domain $withDomain - testing cert $ENV_TESTING - secret cert $ENV_SECRET_CERT

echo setting reverse proxy modules...
ln -s /etc/apache2/mods-available/ssl.conf                 /etc/apache2/mods-enabled/ssl.conf
ln -s /etc/apache2/mods-available/ssl.load                 /etc/apache2/mods-enabled/ssl.load
ln -s /etc/apache2/mods-available/proxy_balancer.conf      /etc/apache2/mods-enabled/proxy_balancer.conf 
ln -s /etc/apache2/mods-available/proxy_http2.load         /etc/apache2/mods-enabled/proxy_http2.load 
ln -s /etc/apache2/mods-available/proxy_balancer.load      /etc/apache2/mods-enabled/proxy_balancer.load 
ln -s /etc/apache2/mods-available/proxy_wstunnel.load      /etc/apache2/mods-enabled/proxy_wstunnel.load 
ln -s /etc/apache2/mods-available/proxy_html.conf          /etc/apache2/mods-enabled/proxy_html.conf 
ln -s /etc/apache2/mods-available/proxy.conf               /etc/apache2/mods-enabled/proxy.conf 
ln -s /etc/apache2/mods-available/proxy_html.load          /etc/apache2/mods-enabled/proxy_html.load 
ln -s /etc/apache2/mods-available/proxy.load               /etc/apache2/mods-enabled/proxy.load 
ln -s /etc/apache2/mods-available/proxy_http.load          /etc/apache2/mods-enabled/proxy_http.load 
ln -s /etc/apache2/mods-available/slotmem_plain.load       /etc/apache2/mods-enabled/slotmem_plain.load 
ln -s /etc/apache2/mods-available/slotmem_shm.load         /etc/apache2/mods-enabled/slotmem_shm.load 
ln -s /etc/apache2/mods-available/rewrite.load             /etc/apache2/mods-enabled/rewrite.load 
ln -s /etc/apache2/mods-available/socache_shmcb.load       /etc/apache2/mods-enabled/socache_shmcb.load 
ln -s /etc/apache2/mods-available/xml2enc.load             /etc/apache2/mods-enabled/xml2enc.load

if [ "$ENV_SECRET_CERT" == "false" ]; then
	export ENV_CERTBOTTESTINGPARAM="--test-cert"
	if [ "$ENV_TESTING" == "no" ]; then
		export ENV_CERTBOTTESTINGPARAM=""
	fi
	certbot --apache --agree-tos -m $ENV_MAIL -d $ENV_DOMAIN -n $ENV_CERTBOTTESTINGPARAM
	echo "IncludeOptional /usr/configs/apache2/*.conf" >> /etc/letsencrypt/options-ssl-apache.conf
else 
	echo "Secret Instructions"
	
	
	ln -s /run/secrets/sslKey /etc/ssl/private/sslKey.key
	ln -s /run/secrets/sslPem /etc/ssl/certs/sslPem.pem
	cp /tmp/secret-ssl.conf /etc/apache2/sites-available/secret-ssl.conf
	
	echo "" >> /etc/apache2/sites-available/secret-ssl.conf
	echo "		ServerName $ENV_DOMAIN" >> /etc/apache2/sites-available/secret-ssl.conf
	echo "		ServerAlias www.$ENV_DOMAIN" >> /etc/apache2/sites-available/secret-ssl.conf
	echo "" >> /etc/apache2/sites-available/secret-ssl.conf
	echo "	</VirtualHost>" >> /etc/apache2/sites-available/secret-ssl.conf
	echo "</IfModule>" >> /etc/apache2/sites-available/secret-ssl.conf


	echo "" > /etc/apache2/sites-available/redirectToHttps.conf
	echo "<VirtualHost *:80>" > /etc/apache2/sites-available/redirectToHttps.conf
	echo "ServerName $ENV_DOMAIN" >> /etc/apache2/sites-available/redirectToHttps.conf
	echo "ServerAlias www.$ENV_DOMAIN" >> /etc/apache2/sites-available/redirectToHttps.conf
	echo "Redirect permanent / https://$ENV_DOMAIN/" >> /etc/apache2/sites-available/redirectToHttps.conf
	echo "</VirtualHost>" >> /etc/apache2/sites-available/redirectToHttps.conf

	echo "" >> /etc/apache2/apache2.conf
	echo "ServerName $ENV_DOMAIN" >> /etc/apache2/apache2.conf
	echo "" >> /etc/apache2/apache2.conf

	ln -s /etc/apache2/sites-available/redirectToHttps.conf /etc/apache2/sites-enabled/redirectToHttps.conf
	ln -s /etc/apache2/sites-available/redirectWWWToHttps.conf /etc/apache2/sites-enabled/redirectWWWToHttps.conf
	ln -s /etc/apache2/sites-available/secret-ssl.conf /etc/apache2/sites-enabled/secret-ssl.conf
	#cat -n /etc/apache2/sites-enabled/secret-ssl.conf 
	
fi




#export vncpasswdPath="$userPath/.vnc"
#if [ ! -d "$vncpasswdPath" ]; then
#    echo "$vncpasswdPath not exists";
#	mkdir -p $vncpasswdPath
#fi


