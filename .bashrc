#
# ~/.bashrc
#
# This file is executed by bash(1) for non-login shells.
#
# Perform following tasks.
# 1. Test if running interactively.
# 2. Configure history options.
# 3. Configure shell options.
# 4. Source files under "~/.bash.d".
# 5. Configure colorful "PS1" prompt if colors are available.
#
# See bash(1) for more options.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the history file, don't overwrite it
# shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Source all files under "~/.bash.d".
if [[ -d ~/.bash.d ]]; then
    # Allow spaces in config file names by setting inter file separator.
    IFS=$(echo -en "\n\b")
    for file in $(ls ~/.bash.d)
    do
        source ~/.bash.d/${file}
    done
    unset IFS
fi

# Use "__colour_enabled()" to check if terminal supports colors.
# See "~/.bash.d/functions" for more info.
unset __colourise_prompt && __colour_enabled && __colourise_prompt=1

# Tell bash to reinterpret PS1 after every command, which is
# required because "__set_bash_prompt()" will return different text and colors
PROMPT_COMMAND=__set_bash_prompt
