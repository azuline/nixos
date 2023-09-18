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

  home.packages = with pkgs; [
    qt5ct
    qt6ct
    # libsForQt5.qtstyleplugins
    # qt6Packages.qt6gtk2
  ];
}
