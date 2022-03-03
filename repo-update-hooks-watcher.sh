#!/usr/bin/env bash
################################################################################
cd ~/dotfiles
export AG_BS_SILENT=true

# tee >(xargs -0 -n1 -I{} echo | gsed -u 's_^_FSWATCH:_g') |

# fswatch -0 -x --exclude index.lock $(git ls-files) $(git ls-files --others --exclude-standard) -t | xargs -0 -n1 -I{} -t 'rm' /tmp/bp_total 
shopt -s expand_aliases
alias stream_view_red='while read line; do printf "\e[01;31m%s\e[0m\n" "$line"; done'
alias stream_view_blue='while read line; do printf "\e[01;34m%s\e[0m\n" "$line"; done'

# kick it off
( sleep 1; touch .bash_eternal_history; ) &

fswatch -0 -x --exclude index.lock $(git ls-files) $(git ls-files --others --exclude-standard) -t \
    | tee -a >(gsed -u -z 's_^_\nFSWATCH:\n_g' | stream_view_red > /dev/tty) \
    | xargs -0 -n1 -I{} 'repo-update-hooks.sh' {} \
    | gsed -u 's_^_XARGS:_' | stream_view_blue

# sed -u is for OUTPUT, not input. Need to make sure you're tracking -0, as
# well. Can add -t to xargs to see debugging output.

# I cant get the damn buffering to stop. It just freezes :/
    # | tee >(xargs -0 -n1 -I{} echo {} | sed -u 's_^_FSWATCH:_g') \
    # | tee >(xargs -0 -n1 -I{} echo {} | sed -u 's_^_FSWATCH:_g') \
    # | xargs -0 -n1 -I{} echo {} | /usr/bin/sed -l 's_^_XARGS:_g' \
