{ pkgs, ... }:

let
  colors = {
    background = "#090910";
    foreground = "#eeffff";
  };
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "300x8-10+10";
        padding = 14;
        horizontal_padding = 10;
        font = "Roboto 11";
      };
      frame = {
        color = "#090910";
      };
      urgency_low = colors;
      urgency_normal = colors;
      urgency_critical = colors;
    };
  };
}
