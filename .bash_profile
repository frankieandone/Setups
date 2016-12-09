#!/usr/bin/env bash
# general development paths
export PATH=/usr/local/bin:/usr/local/sbin:/bin:/usr/sbin:/usr/bin:/sbin
export PATH=$PATH:$HOME
export PATH=$PATH:$HOME/workspace

export PATH=$PATH:$HOME/.rvm/scripts/rvm

# android sdk
export nsdk=$HOME/Library/Android/sdk
export PATH=$PATH:nsdk/tools
export PATH=$PATH:nsdk/platform-tools

# android ndk
export nndk=$HOME/Library/Android/android-ndk-r12b
export PATH=$PATH:nndk

# scala
export PATH=$PATH:$HOME/scala/bin

# git auto completion scripts
# shellcheck source=/Users/fmerzadyan/setups/.git-completion.bash
source $HOME/setups/.git-completion.bash
# shellcheck source=/Users/fmerzadyan/setups/.git-prompt.sh
source $HOME/setups/.git-prompt.sh

# application/program shortcuts
# sublime launcher
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
#set sublime as default editor
export EDITOR="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl -w"
# visual code
code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@";}

# appcelerator titanium shortcuts
# use quotation marks when calling to expand string e.g. cd "$tsdk"
export tsdk="$HOME/Library/Application Support/Titanium"
export tidev=$HOME/workspace/new_titanium_mobile
export tibuild=$tidev/build

alias t='cd "$tsdk" && ls'
alias sconsb='cd "$tibuild" && node scons.js build'
alias sconsp='cd "$tibuild" && node scons.js package'
alias sconsi='cd "$tibuild" && node scons.js install'
alias scons='cd "$tibuild" &&  && sconsb && sconsp && sconsi'
alias prod='appc logout; appc config set defaultEnvironment production; APPC_ENV=production appc login'
alias preprod='appc logout; appc config set defaultEnvironment preproduction; APPC_ENV=preproduction appc login'
alias preprodprod='appc logout; appc config set defaultEnvironment preprodonprod; APPC_ENV=preprodonprod appc login'

# development shortcuts
alias xz='cd $HOME/setups && atom .'
alias show='defaults write com.apple.finder AppleShowAllFiles -bool YES && killall Finder'
alias w='cd $tidev && ls'
alias sw='cd $HOME/Documents/Appcelerator_Studio_Workspace'
alias f='cd $HOME/forgespace && ls'
alias dt='cd $HOME/Desktop'
alias dl='cd $HOME/Downloads'
alias ntest='cd $tidev/build && npm install && node scons.js test android'
alias wedit='cd $tidev && atom .'
alias ndev='appc run -p android -T device'
alias nem='run_android_emulator'
alias iem='open -a Xcode && appc run -p ios'

# stage all modified files but unstage .gitignore then show result
alias git_add='git add -u && git reset HEAD .gitignore && git reset HEAD android/dev/TitaniumTest/assets/Resources/app.js && git status'
alias git_update='git stash && git checkout master && git pull upstream master && git push origin master'
alias git_new='git_new'
alias git_peek='git_show_stash'

# reload .bash_profile after changes
alias reload='. $HOME/.bash_profile'
alias hclean='history -cw && echo '' > $HOME/.bash_history'

# same bash history accross different terminals
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don"t overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Themes
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# FlatUI theme
export PS1='\[\e[00;31m\]\u\[\e[0m\]\[\e[00;35m\]@\[\e[0m\]\[\e[00;32m\]\h\[\e[0m\]\[\e[00;35m\]:\[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]\[\e[00;34m\]$(__git_ps1 " (%s)")\[\e[0m\]\$ '

alias ls='ls -FA'

# custom functions
insert_star() {
	echo -e
	for (( i = 0; i < $(tput cols); i++ )); do
			if [ $((i%2)) -eq 0 ]; then
				printf "*"
			else
				printf " "
			fi
	done
	echo -e
}

run_android_emulator() {
	if [[ ( ! -z $1 ) && ( $1 =~ ^(1[7-9]|2[0-4])$ ) ]]; then
		case "$1" in
			24 )
				ti clean && appc run -p android -T emulator --device-id 6P-API-24
				;;
			23 )
				ti clean && appc run -p android -T emulator --device-id S6-API-23
				;;
			22 )
				ti clean && appc run -p android -T emulator --device-id S6-API-22
				;;
			21 )
				ti clean && appc run -p android -T emulator --device-id S6-API-21-5.0.0
				;;
			19 )
				ti clean && appc run -p android -T emulator --device-id S5-API-19
				;;
			18 )
				ti clean && appc run -p android -T emulator --device-id Xperia-Z-API-18
				;;
			17 )
				ti clean && appc run -p android -T emulator --device-id Xperia-Z-API-17
				;;
		esac
	else
		insert_star
		# shellcheck disable=SC2016
		echo -e 'Usage example:  nem <api-level> e.g. `nem 24`'
		echo -e 'list of emulators:'
		echo -e
		vboxmanage list vms
		insert_star
	fi
}

git_new() {
	if [[ ! -z $1 ]]; then
		git stash
		git checkout master
		git checkout -b "$1"
	fi
}

git_show_stash() {
	if [[ ! -z $1 ]]; then
		"git stash list && git stash show -p stash@{$1}"
	fi
}

# TODO allow history tracking like in finder for going forward
trek() {
	if [[ ! -z $1 ]]; then
		if [[ $1 -lt 0 ]]; then
			for (( i = 0; i < $(( $1 * -1 )); i++ )); do
				cd ..
			done
		fi
	fi
}

# TODO instead of overwriting .bash_res.json file only change specific value for "hook" key
hook() {
	res=$HOME/.bash_res.json
	if [[ ! -e $res ]]; then
		echo -e "$res does not exist so creating"
		touch "$res"
	fi
	# matches any case of pull or p
	if [[ $1 =~ ^[Pp]+[Uu]+[Ll]{2}|[Pp]$ ]]; then
		# shellcheck disable=SC2002
		# hook is the key 
		cd "$(cat "$res" | jq -r ".hook")" || return
	else
		dir=$(pwd)
		echo "{ \"hook\" : \"${dir}\" }" > "$res"
	fi
}

# command line project shortcut
cc() {
	project=$HOME/forgespace/CruiseControl
	if [[ ! -d $project ]]; then
		return
	fi
	if [[ $# -ge 3 ]]; then
		cd "$project" || return
		gradle run -Pin="$1/$2/$3"
	fi
}

# some lines for when coworkers gets too roudy
v() {
	case "$1" in
		1 )
			say -v Tessa -f "$HOME/setups/rough_1.txt" &
			;;
		2 )
			say -v Tessa -f "$HOME/setups/yomama_1.txt" &
			;;
		3 )
			say -v Tessa -f "$HOME/setups/yomama_2.txt" &
			;;
		* )
			;;
	esac
}