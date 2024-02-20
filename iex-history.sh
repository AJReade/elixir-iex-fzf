#!/usr/bin/env zsh
# vim: noai:ts=4:sw=4:expandtab

# exit when a command fails instead of continuing
set -o errexit
# exit when access an unset variable
set -o nounset
# make pipeline fail exit when access an unset variable
set -o pipefail

# (session_name window_id pane_id pane_current_command)
session_name=${1:-$(tmux display -p '#{session_name}')}
window_id=${2:-$(tmux display -p '#{window_id}')}
pane_id=${3:-$(tmux display -p '#{pane_id}')}
pane_current_command=${4:-$(tmux display -p '#{pane_current_command}')}
current_pane=$(printf "%b:%b.%b\n" $session_name $window_id $pane_id)

# if we are not run from an iex aka "beam.smp" pane, exit
if [[ "$pane_current_command" != "beam.smp" ]]; then
    echo "Not in an iex session."
    exit
fi

# Directly use fzf within a tmux split-window, capturing the selection into tmux buffer,
# and then paste it into the target pane.
# tmux split-window -h "iex-history | fzf --multi | tmux load-buffer - ; tmux paste-buffer -t $current_pane"



# mew --> now exits with esc key

signal_file=$(mktemp)

# Ensure fzf allows for normal tab behavior and quitting with Esc
tmux split-window -h "iex-history | fzf --multi --bind 'esc:abort' >$signal_file; if test -s $signal_file; then tmux load-buffer - <\"$signal_file\"; tmux paste-buffer -t $current_pane; else tmux kill-pane; fi"

rm -f "$signal_file"
