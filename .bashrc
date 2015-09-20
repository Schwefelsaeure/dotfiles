#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for file in $(ls ~/.bash.d)
do
	source ~/.bash.d/"$file"
done
