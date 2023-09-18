{ pkgs, ... }:

{
  gtk = {
    enable = true;
    font = {
      size = 11;
      name = "Roboto";
    };
    theme = {
      name = "Plata-Noir-Compact";
      package = pkgs.plata-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
      size = 12;
    };
  };

  # We should set Qt up here, but it didn't really work the way we desired. So
  # instead, we set it at the NixOS level.
}
