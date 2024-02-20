# iex-history

[![asciicast](https://asciinema.org/a/gV4vsp7HTGblsNGBbJvGG75MJ.svg)](https://asciinema.org/a/gV4vsp7HTGblsNGBbJvGG75MJ)

Thank you to [Mrdotb](https://github.com/mrdotb) for the original repo which I have forked.

## The changes:

- Works on macos with Zsh
- When pasting from fzf back to IEX doesn't enter and submit the selected history automatically to the repl
- Allows you to leverage this solution with depending without tmux permanently, tmux only runs when you use the run_iex shell function then quits when we press "F10"
- Exit iex-fzf easily pressing ESC without leaving exit code `o` in the iex repl
- Allows you to open iex to tmux fzf-enabled-mode and pass arguments to leverage this mode regardless of what iex use-case you have
- Run multiple iex tmux sessions that don't effect each other

## Issues

Occasionally the fzf doesn't paste back to the iex repl this is a very intermittent problem I have noticed rarely in this case re-try fzf and it should work perfectly again. If not quit iex-tmux with 'F10' then reload iex however I have never had to do this.

Feel free to raise any issues or suggested improvements/fixes/updates.

Due to the nature of this project using tmux (for now) for pane splitting and piping between terminal sessions it will not work via ssh unless the remote server has tmux & fzf enabled.

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
chmod +x ~/.iex-history/iex-history
chmod +x ~/.iex-history/iex-history.sh
chmod +x ~/.iex-history/iex-history-shortcuts.sh
```

Next we edit our ~/.zshrc file:

I have set my alias shortcut to i then passing argument to that, feel free to do whatever is convenient.

``` zsh
# iex-history plugin
export PATH="<YOUR-HOME>.iex-history:$PATH"

alias i="run_iex"
alias is="run_iex -S mix phx.server"

source ~/.iex-history/iex-history-shortcuts.sh
```
The tmux binding I use is `ctrl-r`, as I only use tmux for iex.
I also use `F10` to exit tmux and iex simultaneously.
The `set -g mouse on` allow you to scroll as normal in tmux.

```bash
bind-key -n F10 send-keys C-\\ \; kill-session
set -g mouse on
bind-key -n C-r run-shell "zsh ~/.iex-history/iex-history.sh #{session_name} #{window_id} #D #{pane_current_command}"
```

Don't forget to reload tmux config, press `^b` then `:` keys and paste below:

```bash
source-file ~/.tmux.conf
```

Also reload your `~/.zshrc` my entering the below in the command line:

```bash
source ~/.zshrc
```
