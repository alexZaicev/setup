# Set appearance of the terminal prompt
if [ ! -f "${HOME}/.git-prompt.sh" ]; then
    curl -Lq https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ${HOME}/.git-prompt.sh
fi
. ${HOME}/.git-prompt.sh

export PS1="[\033[32m\u@\h\033[0m \033[33m\w\033[0m]\033[36m\$(__git_ps1)\033[0m $> "

# Locale
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export CLICOLOR=1
export LSCOLORS="Exfxcxdxbxegedabagacad"
export GREP_OPTIONS="--color=auto"

# Basic PATH cofiguration
export PATH="${PATH}:${HOME}/.gitconfigs"

alias ll="ls -alF"
alias cp="cp -R"
alias mv="mv -f"
alias rm="rm -f"
alias mkdir="mkdir -p"

alias python="python3"
alias pip="pip3"

alias trimcr="sed -i -e 's/\r$//'"

alias gita="git add"
alias gits="clear && git status"
alias gitc="git commit -am"
alias gitp="git push"
alias gitu="git fetch --all && git pull"
alias gitpf="git push --force"

# Uncomment to enable SSH key registration when accessing private Github repositories
# eval "$(ssh-agent -s)"
# DISPLAY=1 SSH_ASKPASS="${HOME}/.git_askpass" ssh-add ${HOME}/.ssh_keys/github_key < /dev/null
