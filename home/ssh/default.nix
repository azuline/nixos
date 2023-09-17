{ pkgs, ... }:

{
  services.ssh-agent.enable = true;
  # Override the default lifetime of SSH keys.
  systemd.user.services.ssh-agent.Service.ExecStart = pkgs.lib.mkForce "${pkgs.openssh}/bin/ssh-agent -t 14400 -D -a %t/ssh-agent";
}
