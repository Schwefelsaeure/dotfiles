#
# ~/.bashrc
#
# This file is executed by bash for non-login shells.
#
# Perform following tasks:
#
#   1. Return if not running interactively.
#   2. Configure shell options.
#   3. Configure history options.
#   4. Source files under "~/.bash.d".
#   5. Configure colorful "PS1" prompt if colors are available.
#
# See bash(1) for more options.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
[[ $DISPLAY ]] && shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
# shopt -s globstar

# Append to the history file, don't overwrite it.
# shopt -s histappend

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Source all files under "~/.bash.d".
if [[ -d ~/.bash.d ]]; then
    # Don't change the inter file separator "IFS" to allow spaces in filenames! Otherwise, "set -o noglob" fails afterwards.
    for file in $(ls ~/.bash.d)
    do
        source ~/.bash.d/${file}
    done
fi

# Tell bash to reinterpret PS1 after every command, which is required because
# "set_bash_prompt()" will return different text and colors.
PROMPT_COMMAND=set_bash_prompt
