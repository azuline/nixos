{ pkgs, ... }:

{
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = null;
  services.gpg-agent.extraConfig = ''
    pinentry-program ${pkgs.pinentry}/bin/pinentry
    default-cache-ttl 14400
    max-cache-ttl 14400
  '';
}
