{ pkgs, specialArgs, ... }:

let
  colorsTheme = builtins.readFile ./colors.rasi;
  splendorSpacingTheme = ''
    element {
      padding: 12px;
      spacing: 10px;
    }
    inputbar {
      padding: 12px;
    }
  '';
  haiqinSpacingTheme = ''
    element {
      padding: 16px;
      spacing: 14px;
    }
    inputbar {
      padding: 16px;
    }
  '';
  neptuneSpacingTheme = ''
    element {
      padding: 12px;
      spacing: 10px;
    }
    inputbar {
      padding: 12px;
    }
  '';
  theme = pkgs.writeText "theme.rasi" ''
    ${colorsTheme}
    * {
      spacing: 0;
    }
    listview {
      lines: 12;
    }
    window {
      padding: 0;
      width:   960px;
      border:  5px;
    }
    inputbar {
      children: [ "prompt", "textbox-prompt-colon", "entry" ];
    }
    ${
      if specialArgs.sys.host == "splendor" then splendorSpacingTheme
      else if specialArgs.sys.host == "haiqin" then haiqinSpacingTheme
      else if specialArgs.sys.host == "neptune" then neptuneSpacingTheme
      else throw "Unsupported host in rofi."
    }
  '';
in
{
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,run,ssh,drun";
      show-icons = true;
      cycle = false;
      terminal = "kitty";
      ssh-client = "ssh";
      icon-theme = "Papirus-Dark";
      display-drun = "Launch";
      font = (
        if specialArgs.sys.host == "splendor" then "Roboto 14"
        else if specialArgs.sys.host == "haiqin" then "Roboto 18"
        else throw "Unsupported host in rofi."
      );
    };
    theme = "${theme}";
  };
}
