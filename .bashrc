# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Favourite editor and pager:
export EDITOR='emacs'
export PAGER='less'
export BROWSER='brave-browser'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=100000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Shell options:
shopt -s cdspell                  # Correct minor typos in directory names on cd command
shopt -s dirspell                 # Correct minor typos in dir names on tab completion
shopt -s checkjobs                # Do not exit if shell has running/suspended jobs

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Make less (much) more powerful by allowing it to read non-ascii files:
# You may have to install a package called lesspipe.
LESS="$LESS -R"
export LESSOPEN="|lesspipe %s"  # May be called lesspipe.sh, path may have to be specified

# Source-code highlighting for less:
# You will need a package called GNU source-highlight (https://www.gnu.org/software/src-highlite/)
# export LESSOPEN="|src-hilite-lesspipe.sh %s"  # Note that this overrides lesspipe above
alias lesscode="LESSOPEN='|src-hilite-lesspipe.sh %s' less"  # Instead, create the 'command' (alias) lesscode

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Colour in man pages to make them easier to navigate (when using less as a pager - see man termcap):
export LESS_TERMCAP_mb=$'\E[01;34m'  # Blinking -> bold blue
export LESS_TERMCAP_md=$'\E[01;34m'  # Bold (section names, cl options) -> bold blue
export LESS_TERMCAP_me=$'\E[0m'      # End bold/blinking
export LESS_TERMCAP_so=$'\E[01;44m'  # Standout mode - pager -> bold white on blue
export LESS_TERMCAP_se=$'\E[0m'      # End standout
export LESS_TERMCAP_us=$'\E[01;31m'  # Underline - variables -> bold red
export LESS_TERMCAP_ue=$'\E[0m'      # End underline
export GROFF_NO_SGR=1

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then

    clr_w='\[\033[12;36m\]' # colour working dir
    clr_p='\[\033[12;32m\]' # colour prompt
    clr_g='\[\033[12;30m\]' # colour prompt
    rest='\[\033[00;00m\]' # reset


    RED="\[\033[01;31m\]"
    YELLOW="\[\033[01;33m\]"
    BROWN="\[\033[03;33m\]"
    GREEN="\[\033[01;32m\]"
    DARKGREEN="\[\033[12;36m\]"
    BLUE="\[\033[01;34m\]"
    DARKBLUE="\[\033[00;34m\]"
    CURBLUE="\[\033[03;34m\]"
    NO_COLOR="\[\033[00m\]"

    function reduce_wd () {
        wd="${PWD/$HOME/\~}" # Current working dir with $HOME substituted by ~
        n=${#wd} # nr of chars in current directory string
        if (( $n > 35)); then
            echo ".../${PWD##*/}" # Reduce size by only printing current directory without path
        else
            echo "$wd"
        fi
    }

    char='\xe2\xa8\xbd\x0a'
    if [ -f ~/.bashrc.d/.gitprompt.sh ]; then
        source ~/.bashrc.d/.gitprompt.sh
        #PS1="[\[\033[1;41m\]\u\[\033[0;1;7m\]@\[\033[0;1;44m\]\h\[\033[0m\] $DARKGREEN\w$NO_COLOR]!# " # root

        PS1="${BROWN}[\d-\t]${NO_COLOR} ${GREEN}\u${NO_COLOR}@${BLUE}\h${NO_COLOR}:${DARKGREEN}\$(reduce_wd)${NO_COLOR}\n${BROWN}⤷\$(__git_ps1)${NO_COLOR}${clr_p}\$ ${NO_COLOR}"       # Normal user
        #PS1="${GREEN}\u${NO_COLOR}@${BLUE}\h${NO_COLOR}${DARKGREEN} $(__git_ps1 " (%s)") ${NO_COLOR}:${DARKGREEN}\w${NO_COLOR}${clr_p}\$ ${NO_COLOR}"       # Normal user
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' # default pop
    else
        #PS1="[\[\033[1;41m\]\u\[\033[0;1;7m\]@\[\033[0;1;44m\]\h\[\033[0m\] $DARKGREEN\w$NO_COLOR]!# " # root
        PS1="${GREEN}\u${NO_COLOR}@${BLUE}\h${NO_COLOR}:${DARKGREEN}\$(reduce_wd)${NO_COLOR}\n${BROWN}⤷${NO_COLOR}${clr_p}\$ ${NO_COLOR}"       # Normal user
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' # default pop
        #PS1="[\[\033[1;31m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \W]\$ "       # Normal user
    fi

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bashrc.d/.bash_aliases ]; then
    . ~/.bashrc.d/.bash_aliases
fi
if [ -f ~/.bashrc.d/.bash_keybindings ]; then
    . ~/.bashrc.d/.bash_keybindings
fi

if [ -f ~./.bashrc.d/.bash_ssh_shortcuts ]; then
    . ~/.bashrc.d/.bash_ssh_shortcuts
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##########################################
# RUST stuff #############################
##########################################
. "$HOME/.cargo/env"

#export LSP_USE_PLISTS=true
