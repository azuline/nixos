{
  pkgs,
  specialArgs,
  themeColors,
  ...
}:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "wd";
        src = specialArgs.srcs.fish-plugin-wd;
      }
      {
        name = "nix-env";
        src = specialArgs.srcs.fish-plugin-nix-env;
      }
    ];
    shellAbbrs = {
      hs = "home-manager switch --flake ${specialArgs.sys.nixDir}/#${specialArgs.sys.host}";
      hsm = "home-manager switch --flake ${specialArgs.sys.nixDir}/#${specialArgs.sys.host}-monitor";
      ns =
        if pkgs.stdenv.isLinux then
          "sudo nixos-rebuild switch --flake ${specialArgs.sys.nixDir}/#${specialArgs.sys.host}"
        else
          "darwin-rebuild switch --flake ${specialArgs.sys.nixDir}/#${specialArgs.sys.host}";
    };
    shellInit = ''
      set -gx PNPM_HOME "$HOME/.local/share/pnpm"
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end
    '';
  };

  xdg.configFile."fish/completions/gh.fish".source = ./completions/gh.fish;
  xdg.configFile."fish/completions/password-store.fish".source = ./completions/password-store.fish;
  xdg.configFile."fish/completions/terraform.fish".source = ./completions/terraform.fish;
  xdg.configFile."fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
  xdg.configFile."fish/functions/pytest.fish".source = ./functions/pytest.fish;
  xdg.configFile."fish/conf.d/aliases.fish".source = ./conf.d/aliases.fish;
  xdg.configFile."fish/conf.d/binds.fish".source = ./conf.d/binds.fish;
  xdg.configFile."fish/conf.d/colors.fish".text = ''
    set fish_color_autosuggestion "888888"
    set fish_color_cancel "\x2dr"
    set fish_color_command "${themeColors.terminal.color12}"
    set fish_color_comment "${themeColors.terminal.color11}"
    set fish_color_cwd "${themeColors.terminal.color11}"
    set fish_color_cwd_root "${themeColors.terminal.color9}"
    set fish_color_end "${themeColors.terminal.color13}"
    set fish_color_error "${themeColors.terminal.color9}"
    set fish_color_escape "${themeColors.terminal.color14}"
    set fish_color_history_current "\x2d\x2dbold"
    set fish_color_host "${themeColors.terminal.color14}"
    set fish_color_host_remote "${themeColors.terminal.color14}"
    set fish_color_kubecontext "${themeColors.terminal.color13}"
    set fish_color_match "\x2d\x2dbackground\x3d${themeColors.terminal.color12}"
    set fish_color_normal "normal"
    set fish_color_operator "${themeColors.terminal.color14}"
    set fish_color_param "${themeColors.terminal.color4}"
    set fish_color_quote "${themeColors.terminal.color10}"
    set fish_color_redirection "${themeColors.terminal.color10}"
    set fish_color_search_match "${themeColors.terminal.color11}\x1e\x2d\x2dbackground\x3d${themeColors.terminal.color8}"
    set fish_color_selection "white\x1e\x2d\x2dbold\x1e\x2d\x2dbackground\x3d${themeColors.terminal.color8}"
    set fish_color_status "${themeColors.terminal.color9}"
    set fish_color_suffix "normal"
    set fish_color_user "${themeColors.terminal.color14}"
    set fish_color_valid_path "\x2d\x2dunderline"
    set fish_greeting
    set fish_key_bindings "fish_default_key_bindings"
    set fish_pager_color_completion "normal"
    set fish_pager_color_description "${themeColors.terminal.color11}\x1eyellow"
    set fish_pager_color_prefix "white\x1e\x2d\x2dbold\x1e\x2d\x2dunderline"
    set fish_pager_color_progress "brwhite\x1e\x2d\x2dbackground\x3dcyan"
    set fish_pager_color_selected_background "\x2dr"
    set fish_prompt_pwd_dir_length "0"
  '';
  xdg.configFile."fish/conf.d/env.fish".source = ./conf.d/env.fish;
  xdg.configFile."fish/conf.d/events.fish".source = ./conf.d/events.fish;
  xdg.configFile."fish/conf.d/fzf.fish".source = ./conf.d/fzf.fish;
  xdg.configFile."fish/conf.d/pytest.fish".source = ./conf.d/pytest.fish;
  xdg.configFile."fish/conf.d/venv.fish".source = ./conf.d/venv.fish;
}
