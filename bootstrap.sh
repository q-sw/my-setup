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
								'--cask drawio' 'packer' )

	for dt in "${DEVOPS_TOOLS[@]}"; do
		brew install $dt
	done

	minikube completion zsh > ~/.minikube-completion
}


# Install productivity tools
function install_productivity_tools(){
	PRODUCTIVITY_TOOLS=('clipy' 'google-chrome' 'adobe-acrobat-reader' 'microsoft-teams'\
			  'spectacle' 'keepassxc' 'microsoft-outlook' 'microsoft-powerpoint'\
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

function setup_vim() {
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	git clone https://github.com/sickill/vim-monokai.git /tmp/monokai
	mv /tmp/monokai/colors ~/.vim/ && rm -rf /tmp/monokai
	ln -s $(pwd)/dot_files/vimrc /tmp
	vim +PluginInstall +qall
}

function setup_tmux() {
	#plugin manager
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	ln -s $(pwd)/dot_files/tmux.conf ~/.tmux.conf
	~/.tmux/plugins/tpm/bin/install_plugin
}

function main(){
	install_homebrew
	install_devops_tools
	install_productivity_tools
	install_zsh_style
	install_vscode_ext
	setup_vim
	setup_tmux

	## TMUX

	## ZSH
	ln -s $(pwd)/dot_files/p10k.zsh ~/.p10k.zsh
	ln -s $(pwd)/dot_files/zshrc ~/.zshrc

	git config credential.helper store
}

main
