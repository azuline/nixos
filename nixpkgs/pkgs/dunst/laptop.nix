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
        font = "Source Code Pro 22";
        format = "<b>%s</b>\\n%b";
        geometry = "640x20-10+10";
        horizontal_padding = 20;
        markup = "full";
        max_icon_size = 72;
        padding = 14;
        vertical_alignment = "top";
        word_wrap = true;
        frame_width = 5;
        frame_color = "#213e68";
      };
      urgency_low = colors;
      urgency_normal = colors;
      urgency_critical = colors;
    };
  };
}
