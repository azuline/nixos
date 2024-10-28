{ pkgs, ... }:

{
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = null;
  services.gpg-agent.extraConfig = ''
    pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
    default-cache-ttl 14400
    max-cache-ttl 14400
  '';
}
