{ pkgs, specialArgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = rec {
      global =
        {
          allow_markup = true;
          history_length = 80;
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
          if specialArgs.screen == "desktop" then
            {
              monitor = 1;
              width = 360;
              height = 720;
              offset = "18x18";
              font = "Source Sans Pro 9";
              horizontal_padding = 12;
              max_icon_size = 48;
            }
          else if specialArgs.screen == "laptop" then
            {
              width = 300;
              height = 600;
              offset = "10x10";
              font = "Source Sans Pro 22";
              horizontal_padding = 20;
              max_icon_size = 72;
            }
          else throw "Invalid screen size in dunst."
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
