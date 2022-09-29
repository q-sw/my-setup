#!/bin/bash

set -e
set -x


# Install homebrew
function install_homebrew() {
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Finalize homebrew installation
	echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/quentin_local/.zprofile
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/quentin_local/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
}

# Install requirements Dev/DevOps tools
function install_devops_tools(){
	DEVOPS_TOOLS=('go' 'terraform' 'docker' 'minikube' 'awscli' 'ansible'\
		      'terragrun' 'terraform-docs' 'tmux' 'virtualenv'\
	      	      '--cask visual-studio-code' '--cask google-cloud-sdk'\
								'--cask drawio' )

	for dt in "${DEVOPS_TOOLS[@]}"; do
		brew install $dt
	done

	minikube completion zsh > ~/.minikube-completion
}


# Install productivity tools
function install_productivity_tools(){
	PRODUCTIVITY_TOOLS=('clipy' 'google-chrome' 'adobe-acrobat-reader' 'microsoft-teams'\
			  'spectacle' 'microsoft-outlook' 'microsoft-powerpoint'\
			  'microsoft-work' 'microsoft-excel')

	for pt in "${PRODUCTIVITY_TOOLS[@]}"; do
		brew install --cask $pt
	done
}

# Install Oh my ZSH - Powerlevel10k
function install_zsh_style(){
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
}

# Install visual studio code extension
function install_vscode_ext(){
	EXTENSION_LIST=('ms-python.python' 'ms-python.vscode-pylance' 'ms-kubernetes-tools.vscode-kubernetes-tools'\
			'clemenspeters.format-json' 'wholroyd.jinja' 'hashicorp.terraform' 'googlecloudtools.cloudcode'\
			'hashicorp.hcl' 'golang.go' 'mhutchie.git-graph' 'ms-azuretools.vscode-docker')

	for extension in "${EXTENSION_LIST[@]}"; do
		code --install-extension $extension
	done
}

# Configure dot file
## VIM

## TMUX

## ZSH

function main(){
	install_homebrew
	install_devops_tools
	install_productivity_tools
	install_zsh_style
	install_vscode_ext
}

main
