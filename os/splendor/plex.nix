{ ... }:

{
  services.plex = {
    enable = true;
    user = "plex";
    group = "media";
    openFirewall = false;
  };
}
