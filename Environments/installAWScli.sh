# Install AWScli
if test ! $(which aws)
then
	echo "Installing awscli..."
	brew install awscli
	chmod 755 /usr/local/lib/pkgconfig
	brew link awscli

else
	echo "Upgrading awscli..."
	brew upgrade awscli
fi

awscliversion=$(aws --version)
