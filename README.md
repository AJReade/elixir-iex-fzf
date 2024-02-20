# iex-history

[![asciicast](https://asciinema.org/a/gV4vsp7HTGblsNGBbJvGG75MJ.svg)](https://asciinema.org/a/gV4vsp7HTGblsNGBbJvGG75MJ)

Thank you to [Mrdotb](https://github.com/mrdotb) for the original repo which I have forked.

## The changes:

- Works on macos with Zsh
- when pasting from fzf back to IEX doesn't enter automatically
- Allows you to leverage this solution with depending with tmux permanently, tmux only runs when you run the run_iex shell function then quits when we press "F10"
- Exit iex-fzf easily pressing ESC without leaving exit code o in the iex repl
- Allows you to open iex to tmux fzf enabled mode and pass arguments to leverage this mode regardless of what iex use-case you have
- Run multiple iex tmux sessions that don't effect each other

## Issues

Occasionally the fzf doesn't paste back to the iex repl this is a very intermittent problem I have noticed rarely in this case re-try fzf and it should work perfectly again. If not quit iex-tmux with 'F10' then reload iex however I have never had to do this.

Feel free to raise any issues or suggested improvements/fixes/updates.

## Installation

Hard requirements:

- erlang with history enabled [how to ?](https://til.hashrocket.com/posts/is9yfvhdnp-enable-history-in-iex-through-erlang-otp-20-)
- [tmux](https://github.com/tmux/tmux/) :warning: version 3 or more
- [fzf](https://github.com/junegunn/fzf)
- [bash](https://www.gnu.org/software/bash/)

### MacOS Set up:

#### install tmux

```shell
 brew install tmux
 ```

#### install fzf

See [here](https://github.com/junegunn/fzf) for latest


### Project installation:

Run the following to your terminal I put in ~ but feel free to put it where you want

```shell
git clone https://github.com/AJReade/elixir-iex-fzf ~/.iex-history
cd ~/.iex-history
MIX_ENV=prod mix escript.build
```

Next to ensure the binary & shell script can execute:

**read the shell code for your self execute at own risk.**

``` shell
chmod +x /Users/ar/.iex-history/iex-history
chmod +x /Users/ar/.iex-history/iex-history.sh
```

Next we edit our ~/.zshrc file:

I have set my alias shortcut to i then passing argument to that, feel free to do whatever is convenient.

``` zsh
# history plugin
export PATH="/Users/ar/.iex-history:$PATH"

alias i="run_iex"
alias is="run_iex -S mix phx.server"

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

```

Last step is to add the following line in your tmux config (.tmux.conf) to call the script.
The tmux binding I use is `ctrl-r`, as I only use tmux for iex.
I also use 'fnF10' to exit tmux and iex simultaneously.
The 'set -g mouse on' allow you to scroll as normal in tmux.

```bash
bind-key -n F10 send-keys C-\\ \; kill-session
set -g mouse on
bind-key -n C-r run-shell "zsh ~/.iex-history/iex-history.sh #{session_name} #{window_id} #D #{pane_current_command}"
```

Don't forget to reload tmux config, press "^b" then ":" keys and paste below:

```bash
source-file ~/.tmux.conf
```

Also reload your ~/.zshrc my entering the below in the command line:

```bash
source ~/.zshrc
```
