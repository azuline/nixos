{ pkgs, ... }:

{
  home.packages = [ pkgs.gh ];
  xdg.configFile."gh/config.yml".text = ''
    # What protocol to use when performing git operations. Supported values: ssh, https
    git_protocol: ssh
    # What editor gh should run when creating issues, pull requests, etc. If blank, will refer to environment.
    editor: !!null nvim
    # When to interactively prompt. This is a global config that cannot be overridden by hostname. Supported values: enabled, disabled
    prompt: enabled
    # A pager program to send command output to, e.g. "less". Set the value to "cat" to disable the pager.
    pager:
    # Aliases allow you to create nicknames for gh commands
    aliases:
        co: pr checkout
        rw: repo view -w
        pst: pr status
        prc: pr create
        pre: pr edit
        prw: pr view --web
        prm: pr merge --auto --squash --delete-branch
    browser: ${if pkgs.stdenv.isDarwin then "open -a firefox" else "firefox"}
    version: "1"
  '';
}
