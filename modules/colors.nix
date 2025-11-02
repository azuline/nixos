{ specialArgs, ... }:

let
  theme = specialArgs.sys.theme or "cool";

  coolColors = {
    # 16 base terminal colors (ANSI)
    terminal = {
      # Black
      color0 = "#30384c";
      color8 = "#3e465b";
      # Red
      color1 = "#f77669";
      color9 = "#ff5370";
      # Green
      color2 = "#8bd649";
      color10 = "#c3e88d";
      # Yellow
      color3 = "#ffcb6b";
      color11 = "#f1e655";
      # Blue (primary theme color)
      color4 = "#7986e7";
      color12 = "#8eace3";
      # Magenta
      color5 = "#c792ea";
      color13 = "#939ede";
      # Cyan
      color6 = "#82b1ff";
      color14 = "#89ddff";
      # White
      color7 = "#d9f55d";
      color15 = "#eeffff";
    };

    # Primary color palette (blue shades: darkest -> lightest)
    primary = {
      shade1 = "#182130";   # Darkest - Very dark blue-grey
      shade2 = "#213148";   # Dark blue-grey
      shade3 = "#213e68";   # Medium-dark blue
      shade4 = "#376181";   # Base blue (main accent)
      shade5 = "#265476";   # Medium blue
      shade6 = "#8eace3";   # Light blue
      shade7 = "#82b1ff";   # Lighter blue
      shade8 = "#89ddff";   # Lightest - Lightest cyan-blue
    };

    # Common UI colors
    ui = {
      background = "#090910";
      foreground = "#eeffff";
      alert = "#ff5370";
      border = "#265476";  # Blue border (shade5 - lighter, more visible)
    };
  };

  warmColors = {
    # 16 base terminal colors (ANSI) - warm tones with increased contrast
    terminal = {
      # Black
      color0 = "#3d2820";
      color8 = "#5a4438";
      # Red - keep as actual red
      color1 = "#d96446";
      color9 = "#ff6b4a";
      # Green - warm olive/moss green
      color2 = "#a8b565";
      color10 = "#d4dc6b";
      # Yellow - warm gold/amber
      color3 = "#e0a04e";
      color11 = "#ffb865";
      # Blue - muted dusty blue-grey (same hue, increased lightness)
      color4 = "#7a8a9d";
      color12 = "#adc0d5";
      # Magenta - warm mauve/rose
      color5 = "#d4896e";
      color13 = "#ff9d88";
      # Cyan - warm rust/orange/brown (primary theme color)
      color6 = "#c85a3e";
      color14 = "#ff8866";
      # White
      color7 = "#e8d3b8";
      color15 = "#fef9f0";
    };

    # Primary color palette (rust/brown shades: darkest -> lightest)
    primary = {
      shade1 = "#2d1810";   # Darkest - Very dark brown
      shade2 = "#442418";   # Dark brown
      shade3 = "#5e3020";   # Medium-dark rust-brown
      shade4 = "#c85a3e";   # Base rust/burnt orange (main accent)
      shade5 = "#7a3e28";   # Medium brown-rust
      shade6 = "#d87555";   # Light rust-orange
      shade7 = "#c89068";   # Lighter warm tan
      shade8 = "#d7a67d";   # Lightest - Lightest warm beige
    };

    # Common UI colors
    ui = {
      background = "#1b1009";
      foreground = "#fef9f0";
      alert = "#e67350";
      border = "#7a3e28";  # Warm border (shade5 - lighter, more visible)
    };
  };

  colors = if theme == "warm" then warmColors else coolColors;
in
{
  # Export colors for use by other modules
  home.sessionVariables = {
    THEME_NAME = theme;
  };

  # This module just provides the colors structure
  _module.args.themeColors = colors;
}
