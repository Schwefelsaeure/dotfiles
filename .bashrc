#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Allow spaces in filenames
IFS=$(echo -en "\n\b")

for file in $(ls ~/.bash.d)
do
            source ~/.bash.d/"$file"
done

unset IFS
