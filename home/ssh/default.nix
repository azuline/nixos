{ pkgs, lib, ... }:

# ssh-agent is not supported on MacOS, but we do not need it, because of `UseKeychain true`.
lib.mkIf pkgs.stdenv.isLinux {
  services.ssh-agent.enable = true;
  # Override the default lifetime of SSH keys.
  systemd.user.services.ssh-agent.Service.ExecStart =
    pkgs.lib.mkForce "${pkgs.openssh}/bin/ssh-agent -t 14400 -D -a %t/ssh-agent";
}
