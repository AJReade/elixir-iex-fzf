function run_iex() {

  local session=$(date | sha256sum | cut -c1-8)

  local current_session=${1:-$(tmux display -p '#{session_name}')}

  local command='iex'

  if [ "$#" -gt 0 ]; then
    command+=" $@"
  fi

  # Determine the current directory
  local current_dir="$(pwd)"

  if [ -n "$TMUX" ]; then
    echo "Already in a tmux session. Switching to 'iex_session'..."
    # Send 'cd' to the current directory and clear the screen
    tmux send-keys -t "$current_session" "cd ${current_dir}" C-m \; send-keys -t "$current_session" "clear" C-m
    # Then send the command
    tmux send-keys -t "$current_session" "$command" C-m
  else
    # Create a new session with the current directory and run the command
    tmux new-session -d -s "$session" -c "$current_dir"
    tmux send-keys -t "$session" "$command" C-m
    if [ -z "$TMUX" ]; then
      tmux attach -t "$session"
    fi
  fi
}
