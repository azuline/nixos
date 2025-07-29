{ pkgs, specialArgs, ... }:

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
  xdg.configFile."fish/conf.d/colors.fish".source = ./conf.d/colors.fish;
  xdg.configFile."fish/conf.d/env.fish".source = ./conf.d/env.fish;
  xdg.configFile."fish/conf.d/events.fish".source = ./conf.d/events.fish;
  xdg.configFile."fish/conf.d/pytest.fish".source = ./conf.d/pytest.fish;
  xdg.configFile."fish/conf.d/venv.fish".source = ./conf.d/venv.fish;
}
