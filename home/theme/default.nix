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
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = true
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = {
    size = 56;
    name = "Nordzy-cursors";
    package = pkgs.nordzy-cursor-theme;
    x11.enable = true;
  };
  # We set this here to ensure that the pointerCursor `xsetroot` command gets
  # written.
  xsession.enable = true;

  # We should set Qt up here, but it didn't really work the way we desired. So
  # instead, we set it at the NixOS level.
}
