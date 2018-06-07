# load zsh plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# set prompt
prompt_pwd() {
    PWD=`pwd`
    ESCAPED_HOME=$(sed -e 's/\//\\\//g' <<< $HOME)
    DIR=$(sed -e "s/$ESCAPED_HOME/~/" <<< $PWD)

    P=""

    ARRAY=(${(s:/:)DIR})
    LENGTH=${#ARRAY[@]}
    for i in {0..$LENGTH}
    do
        VALUE="$ARRAY[$i]"

        if [ $i -eq $LENGTH ]
        then
            if [ $LENGTH -eq 1 ] && [ $VALUE = "~" ]
            then
                P+="$VALUE"
            else
                P+="/$VALUE"
            fi
        elif [ "$VALUE" = "~" ]
        then
            P+="$ARRAY[$i]"
        elif [ "$VALUE" != "" ]
        then
            P+="/$VALUE[0,1]"
        fi
    done

    echo $P
}

setopt PROMPT_SUBST
PROMPT='%n@%m $(prompt_pwd)> '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# setup history
export HISTSIZE=25000
export HISTFILE=~/.histfile
export SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# update path
export PATH="$HOME/.cargo/bin:$PATH"

# add dotfiles alias
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/hamersaw/.sdkman"
[[ -s "/home/hamersaw/.sdkman/bin/sdkman-init.sh" ]] && source "/home/hamersaw/.sdkman/bin/sdkman-init.sh"
