install: install-pre install-opt install-dev
install-pre:
	sudo apt-add-repository ppa:git-core/ppa -y
	sudo apt update
	sudo apt install \
		apt-transport-https \
		curl \
		cmake \
		git \
		ca-certificates \
		gnupg-agent \
		software-properties-common

install-opt: iopt-brave iopt-spotify iopt-docker iopt-gcloud iopt-vscode iopt-nodejs
	@echo "https://slack.com/intl/en-no/downloads/linux"
	@echo "https://www.google.com/chrome/"
	@echo "https://discordapp.com/download"

# https://brave-browser.readthedocs.io/en/latest/installing-brave.html
iopt-brave:
	curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
	echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update
	sudo apt install brave-browser

# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository
iopt-docker:
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
	sudo apt update
	sudo apt install docker-ce docker-ce-cli containerd.io

# https://www.spotify.com/no/download/linux/
iopt-spotify:
	curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt update
	sudo apt install spotify-client

# https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu#before-you-begin
iopt-gcloud:
	echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
	sudo apt update
	sudo apt install google-cloud-sdk

# https://code.visualstudio.com/docs/setup/linux#_installation
iopt-vscode:
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
	sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt update
	sudo apt install code

# https://github.com/nodesource/distributions/blob/master/README.md#debmanual
iopt-nodejs:
	curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
	echo "deb https://deb.nodesource.com/node_12.x bionic main" | sudo tee /etc/apt/sources.list.d/nodesource.list
	echo "deb-src https://deb.nodesource.com/node_12.x bionic main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
	sudo apt update
	sudo apt install nodejs

install-dev:
	sudo apt install \
		autoconf \
		automake \
		autotools-dev \
		bsdmainutils \
		build-essential \
		curl \
		emacs \
		htop \
		kubectl \
		lib32readline-dev \
		lib32readline7 \
		libbz2-dev \
		libcurl \
		libevent-dev \
		libffi-dev \
		liblzma-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		llvm \
		openssl \
		pass \
		pkg-config \
		protobuf-compiler \
		python-openssl \
		python3-pip \
		silversearcher-ag \
		tk-dev \
		tmux \
		wget \
		xclip \
		xz-utils \
		zlib1g-dev \
		xsel

	sudo pip3 install virtualenv
	curl https://pyenv.run | bash
