{ pkgs, specialArgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = rec {
      global = {
        allow_markup = true;
        history_length = 80;
        monitor = 0;
        width = 360;
        height = 360;
        font = "Source Code Pro 10";
        horizontal_padding = 12;
        max_icon_size = 48;
        separator_height = 4;
        format = "<b>%s</b>\\n%b";
        markup = "full";
        padding = 14;
        corner_radius = 2;
        vertical_alignment = "top";
        word_wrap = true;
        frame_width = 3;
        frame_color = "#213e68";
      } // (
        if specialArgs.sys.host == "splendor" then {
          offset = "10x10";
        } else if specialArgs.sys.host == "haiqin" then {
          offset = "5x5";
        } else throw "Invalid host in dunst."
      );
      urgency_low = {
        background = "#090910";
        foreground = "#eeffff";
      };
      urgency_normal = urgency_low;
      urgency_critical = urgency_low;
    };
  };
}
