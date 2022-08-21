{ pkgs, specialArgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      hs = "home-manager switch --flake ${specialArgs.nixDir}/#${specialArgs.host}";
    };
    plugins = [
      {
        name = "wd";
        src = pkgs.fetchFromGitHub {
          owner = "fischerling";
          repo = "plugin-wd";
          rev = "6cf653b199328c17c1e4b40d20a459e32316e43c";
          sha256 = "1cjca89pgdcq5bg828kkran73c2mr00bkpaqh8qn1mw5p8xqci5m";
        };
      }
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
    ];
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
