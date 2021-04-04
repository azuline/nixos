{ pkgs, ... }:

let
  colors = {
    background = "#090910";
    foreground = "#eeffff";
  };
in
{
  home.packages = [ pkgs.dunst ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        allow_markup = true;
        font = "Source Code Pro 9";
        format = "<b>%s</b>\\n%b";
        geometry = "300x8-10+10";
        horizontal_padding = 12;
        markup = "full";
        max_icon_size = 32;
        padding = 14;
        word_wrap = true;
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
