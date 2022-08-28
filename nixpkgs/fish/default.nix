{ pkgs, specialArgs, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "wd";
        src = specialArgs.src.fish-plugin-wd;
      }
      {
        name = "nix-env";
        src = specialArgs.src.fish-plugin-nix-env;
      }
    ];
    shellAbbrs = {
      hs = "home-manager switch --flake ${specialArgs.nixDir}/#${specialArgs.host}";
    };
  };

  xdg.configFile."fish/completions/gh.fish".source = ./completions/gh.fish;
  xdg.configFile."fish/completions/password-store.fish".source = ./completions/password-store.fish;
  xdg.configFile."fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
  xdg.configFile."fish/conf.d/aliases.fish".source = ./conf.d/aliases.fish;
  xdg.configFile."fish/conf.d/colors.fish".source = ./conf.d/colors.fish;
  xdg.configFile."fish/conf.d/env.fish".source = ./conf.d/env.fish;
  xdg.configFile."fish/conf.d/events.fish".source = ./conf.d/events.fish;
  xdg.configFile."fish/conf.d/venv.fish".source = ./conf.d/venv.fish;
}
