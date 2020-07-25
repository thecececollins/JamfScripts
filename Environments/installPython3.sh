# Install Python Packages
if test ! $(which python3)
then
	echo "Installing python3..."
	brew install python3
else
	echo "Upgrading python3..."
	brew update
    brew cleanup
	brew upgrade python3
    brew cleanup python3
fi
	
python3version=$(python3 --version)
