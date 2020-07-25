# Install pyenv
"$JH" -windowType utility -title "$TITLE" -heading "Base Development Environment Setup" -description "$pipversion and $brewversion are installed, now we'll configure your Python Environment. Here we go!" -button1 "Super!" -icon "$ICON" -alignDescription natural -alignHeading natural


if test ! $(which pyenv)
then
	echo "Installing pyenv..."
	brew install readline xz pyenv pyenv-virtualenv
else
	echo "Upgrading pyenv..."
	brew upgrade pyenv
fi

pyenvversion=$(pyenv -v)
