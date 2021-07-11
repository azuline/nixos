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
        geometry = "360x8-10+10";
        horizontal_padding = 12;
        markup = "full";
        max_icon_size = 48;
        padding = 14;
        vertical_alignment = "top";
        word_wrap = true;
        frame_width = 3;
        frame_color = "#213e68";
      };
      urgency_low = colors;
      urgency_normal = colors;
      urgency_critical = colors;
    };
  };
}
