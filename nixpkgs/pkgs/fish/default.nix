{ pkgs, ... }:

{
  programs.fish.enable = true;

  xdg.configFile."fish/completions/gh.fish".source = ./completions/gh.fish;
  xdg.configFile."fish/completions/password-store.fish".source = ./completions/password-store.fish;
  xdg.configFile."fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
  xdg.configFile."fish/conf.d/aliases.fish".source = ./conf.d/aliases.fish;
  xdg.configFile."fish/conf.d/colors.fish".source = ./conf.d/colors.fish;
  xdg.configFile."fish/conf.d/env.fish".source = ./conf.d/env.fish;
  xdg.configFile."fish/conf.d/events.fish".source = ./conf.d/events.fish;
  xdg.configFile."fish/conf.d/venv.fish".source = ./conf.d/venv.fish;
}
