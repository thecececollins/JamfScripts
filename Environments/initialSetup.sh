#!/bin/bash
#PLATFORM=`uname -s`
#TALOS_ROOT=$PWD

JH=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
TITLE="Company Name"
ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
ADESC="Natural"


"$JH" -windowType utility -title "$TITLE" -heading "Dev Environment Setup" -description "We are going to gather some information in order to configure your new engineering environment." -button1 "Let's do this!" -icon "$ICON" -alignDescription natural -alignHeading natural

# End user prompt to collect the AWS Access Key ID
AWS_ACCESS_KEY_ID=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your AWS Access Key ID: " default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
#read $AWS_ACCESS_KEY_ID

# End user prompt to collect the AWS Secret Access Key
AWS_SECRET_ACCESS_KEY=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your AWS Secret Access Key: " default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
#read $AWS_SECRET_ACCESS_KEY

# End user prompt to collect the NPM Auth Token
NPM_AUTH_TOKEN=$(/usr/bin/osascript <<-'__EOF__'
tell application "System Events"
	activate
	set input to display dialog "Please enter your NPM Auth Token: " default answer "" buttons {"OK"} default button 1
	return text returned of input as string
end tell
__EOF__
)
#read $NPM_AUTH_TOKEN

## Format information #####


displayInfo="AWScli Information
----------------------------------------------
AWS Access Key ID: $AWS_ACCESS_KEY_ID
AWS SecretAccess Key: $AWS_SECRET_ACCESS_KEY
NPM Auth Token: $NPM_AUTH_TOKEN
----------------------------------------------


Choose your own adventure below..."



## Display information to end user #####
runCommand="button returned of (display dialog \"$displayInfo\" with title \"AWScli Information\" with icon file posix file \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarInfo.icns\" buttons {\"Update information\",\"Let's begin!\"} default button {\"Let's begin!\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )

## Run additional commands #####


if [ "$clickedButton" = "Update Information" ]; then

	# open a remote support application
	# /usr/bin/open -a "/Applications/TeamViewer.app"

	# run a policy to enable remote support
	# /usr/local/bin/jamf policy -event EnableRemoteSupport
	
	# email computer information to help desk
	currentUser=$( stat -f "%Su" /dev/console )
	sudo -u "$currentUser" /usr/bin/open "mailto:support@talkingmoose.pvt?subject=Computer Information ($serialNumber)&body=$displayInfo"
	
	if [ $? = 0 ]; then
		/usr/bin/osascript -e 'display dialog "Remote support enabled." with title "Computer Information" with icon file posix file "/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns" buttons {"OK"} default button {"OK"}' &
	else
		/usr/bin/osascript -e 'display dialog "Failed enabling remote support." with title "Computer Information" with icon file posix file "/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns" buttons {"OK"} default button {"OK"}' &
	fi
	
fi

# Configuring the dev environment

"$JH" -windowType utility -title "$TITLE" -heading "Time to setup!" -description "Now that we have what we need, we'll start configuring your new engineering environment. Starting with installing HomeBrew... hang tight as all of this happens in the background but we'll keep you posted along the way." -button1 "Sweet!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Install Brew
if test ! $(which brew)
then
	echo "Installing HomeBrew..."
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
else
	echo "Upgrading HomeBrew..."
	brew update
	brew cleanup
fi

# REPLACEME with your own dotfiles
# bash -c "$(curl -fsSL raw.github.com/zgallup/dotfiles/master/install)"

"$JH" -windowType utility -title "$TITLE" -heading "Python Environment" -description "HomeBrew is installed, now we'll configure your Python Environment. Here we go!" -button1 "Super!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Install pyenv
if test ! $(which pyenv)
then
	echo "Installing pyenv..."
	if [ $PLATFORM == Darwin ]
	then
		brew install pyenv
		echo 'eval "$(pyenv init -)"' >> ~/.zshrc
		pyenv install 3.6.8 --force
	elif [ $PLATFORM == Linux ]
	then
		curl https://pyenv.run | bash
		pyenv update
	else
		echo "Problem installing pyenv"
		exit 1
	fi
else
	echo "Upgrading pyenv..."
	if [ $PLATFORM == Darwin ]
	then
		brew upgrade pyenv
	elif [ $PLATFORM == Linux ]
	then
		pyenv update
	else
		echo "Problem upgrading pyenv"
		exit 1
	fi
fi

"$JH" -windowType utility -title "$TITLE" -heading "NPM" -description "Python Environment is installed, NPM is now up to bat!" -button1 "Heck yes!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Install NPM
if [ $PLATFORM == Darwin ]
then
	brew install node
	brew install npm
elif [ $PLATFORM == Linux ]
then
	sudo apt install nodejs -y
	sudo apt install npm -y
else
	echo "Problem installing NPM"
	exit 1
fi

"$JH" -windowType utility -title "$TITLE" -heading "Redis & Docker" -description "Python Environment is installed, now we'll configure Redis and Docker. Brace yourself." -button1 "Braced!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Install Redis
if [ $PLATFORM == Darwin ]
then
	brew install redis
	brew services start redis
elif [ $PLATFORM == Linux ]
then
	wget http://download.redis.io/redis-stable.tar.gz
	tar xvzf redis-stable.tar.gz
	cd redis-stable
	make
	redis-server &
else
	echo "Problem installing Redis"
	exit 1
fi

if test ! $(which docker)
then
	# Install Docker
	echo "Installing Docker"
	if [ $PLATFORM == Darwin ]
	then
		brew cask install docker
	elif [ $PLATFORM == Linux ]
	then
		curl -fsSL https://get.docker.com -o get-docker.sh
		sh get-docker.sh
	else
		echo "Problem installing Docker"
		exit 1
	fi
else
	# Upgrade Docker
	echo "Upgrading docker..."
	if [ $PLATFORM == Darwin ]
	then
		brew upgrade docker
	elif [ $PLATFORM == Linux ]
	then
		curl -fsSL https://get.docker.com -o get-docker.sh
		sh get-docker.sh
	else
		echo "Problem upgrading docker"
		exit 1
	fi
fi

"$JH" -windowType utility -title "$TITLE" -heading "Python Packages" -description "Redis and Docker are installed, now we'll install the Python packages. Almost at the end!" -button1 "Yes!" -icon "$ICON" -alignDescription natural -alignHeading natural

PYTHON_PACKAGES=(
	virtualenv
	awscli
	black
	isort==4.3.16
	flake8==3.5.0
)

# Install Python Packages
sudo pip install ${PYTHON_PACKAGES[@]}

"$JH" -windowType utility -title "$TITLE" -heading "AWScli" -description "Python packages are installed, now all of your inputted data will be put to use! Time to set up AWScli." -button1 "Cool!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Setup AWScli
echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >> ~/.zshrc
echo "source AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ~/.zshrc
echo "export NPM_AUTH_TOKEN=$NPM_AUTH_TOKEN" >> ~/.zshrc

"$JH" -windowType utility -title "$TITLE" -heading "githooks" -description "AWScli is configured, now we'll setup githooks. It's almost closing time..." -button1 "Super!" -icon "$ICON" -alignDescription natural -alignHeading natural


# Replace githooks section with this:
###### https://github.com/NarrativeScience/talos/blob/master/README.md#run-linting-and-formatting
pip install flake8==3.5.0
pip install isort==4.3.16
pip install black
git config --local core.hooksPath .githooks
brew install npm
npm install -g gherkin-lint

# Install the framework
git config --unset core.hooksPath
pip install pre-commit
pre-commit install

# Setup githooks
#git config --local core.hooksPath .githooks

#"$JH" -windowType utility -title "$TITLE" -heading "GherkinLint" -description "HomeBrew is installed, now we'll configure your Python Environment. The end is near..." -button1 "Bring it!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Install GherkinLint
npm install -g gherkin-lint

"$JH" -windowType utility -title "$TITLE" -heading "Postgres Directory" -description "githooks is installed, now we'll install GherkinLint. Here we go!" -button1 "Super!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Create Postgres Directory
sudo mkdir -p /usr/local/opt/talos-postgres
sudo chown -R $USER /usr/local/opt/talos-postgres

"$JH" -windowType utility -title "$TITLE" -heading "It's Talos Time!" -description "Postgres Directory is setup, now we'll create and update Talos. Last step!" -button1 "Baller!" -icon "$ICON" -alignDescription natural -alignHeading natural

# Create and Update Talos
zsh --rcfile <(echo '. ~/.zshrc; pyenv global 3.6.8; pyenv shell 3.6.8;eval updateTalos;eval setupPostgres')

"$JH" -windowType utility -title "$TITLE" -heading "Complete" -description "That wasn't too painful. Now you have the foundation of your dev environment configured. Congrats!" -button1 "Cheers!" -icon "$ICON" -alignDescription natural -alignHeading natural
