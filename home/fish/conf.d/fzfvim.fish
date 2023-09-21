# A custom keybind to launch fzf and edit the loaded file in vim.
# Forked from fzf-cf-widget found here: https://github.com/junegunn/fzf/blob/2bed7d370e3ff654542aec0e9ad698dac64f244b/shell/key-bindings.fish#L75.
function fzf-vim-widget 
  set -l commandline (__fzf_parse_commandline)
  set -l dir $commandline[1]
  set -l fzf_query $commandline[2]
  set -l prefix $commandline[3]

  test -n "$FZF_CTRL_G_COMMAND"; or set -l FZF_CTRL_G_COMMAND "
  command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
  -o -type f -print 2> /dev/null | sed 's@^\./@@'"
  test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
  begin
    set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --scheme=path --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_G_OPTS"
    eval "$FZF_CTRL_G_COMMAND | "(__fzfcmd)' +m --query "'$fzf_query'"' | read -l result

    if [ -n "$result" ]
      vim -- $result

      # Remove last token from commandline.
      commandline -t ""
      commandline -it -- $prefix
    end
  end

  commandline -f repaint
end

bind \cg fzf-vim-widget
