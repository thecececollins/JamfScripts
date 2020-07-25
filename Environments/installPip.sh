#  Install pip
if test ! $(which pip)
then
	echo "Installing pip..."
	sudo easy_install pip
else
	echo "Upgrading pip..."
	sudo pip install --upgrade pip
fi

pipversion=$(pip --version)
