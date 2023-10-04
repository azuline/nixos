{ pkgs, ... }:

{
  services.transmission = {
    enable = true;
    user = "transmission";
    group = "media";
    home = "/var/lib/transmission";
    openPeerPorts = true;
    openRPCPort = false;
    performanceNetParameters = true;
    credentialsFile = "/etc/nixos/os/splendor/transmission-credentials.json";
    settings = {
      alt-speed-down = 200;
      alt-speed-enabled = false;
      alt-speed-time-begin = 540;
      alt-speed-time-day = 127;
      alt-speed-time-enabled = false;
      alt-speed-time-end = 1020;
      alt-speed-up = 200;
      announce-ip = "";
      announce-ip-enabled = false;
      anti-brute-force-enabled = false;
      anti-brute-force-threshold = 100;
      bind-address-ipv4 = "0.0.0.0";
      bind-address-ipv6 = "::";
      blocklist-enabled = false;
      blocklist-url = "http://www.example.com/blocklist";
      cache-size-mb = 4;
      default-trackers = "";
      dht-enabled = false;
      download-dir = "/mnt/elements/misc";
      download-limit = 100;
      download-limit-enabled = 0;
      download-queue-enabled = true;
      download-queue-size = 5;
      encryption = 1;
      idle-seeding-limit = 34463;
      idle-seeding-limit-enabled = false;
      incomplete-dir = "/mnt/elements/tmp";
      incomplete-dir-enabled = true;
      lpd-enabled = false;
      # I think if this is less than peer-limit-per-torrent *
      # download-queue-size, the RPC connection can be rejected.
      max-peers-global = 80;
      message-level = 2;
      peer-congestion-algorithm = "";
      peer-id-ttl-hours = 6;
      peer-limit-global = 100;
      peer-limit-per-torrent = 12;
      peer-port = 56001;
      peer-port-random-high = 65535;
      peer-port-random-low = 49152;
      peer-port-random-on-start = false;
      peer-socket-tos = "le";
      pex-enabled = false;
      port-forwarding-enabled = false;
      preallocation = 1;
      prefetch-enabled = true;
      queue-stalled-enabled = true;
      queue-stalled-minutes = 10;
      ratio-limit = 2;
      ratio-limit-enabled = false;
      rename-partial-files = true;
      scrape-paused-torrents-enabled = false;
      script-torrent-added-enabled = false;
      script-torrent-added-filename = null;
      script-torrent-done-enabled = false;
      script-torrent-done-filename = null;
      script-torrent-done-seeding-enabled = false;
      script-torrent-done-seeding-filename = null;
      seed-queue-enabled = false;
      seed-queue-size = 10;
      speed-limit-down = 40000;
      speed-limit-down-enabled = true;
      speed-limit-up = 20000;
      speed-limit-up-enabled = true;
      start-added-torrents = true;
      tcp-enabled = true;
      torrent-added-verify-mode = "fast";
      trash-original-torrent-files = true;
      umask = 027;
      upload-limit = 100;
      upload-limit-enabled = false;
      upload-slots-per-torrent = 15;
      utp-enabled = true;
      watch-dir = "/home/blissful/downloads/torrents";
      watch-dir-enabled = true;
    };
  };

  # The NixOS systemd service restricts writes to the explicitly configured
  # BindPaths.
  systemd.services.transmission.serviceConfig.BindPaths = [ "/mnt/elements" ];

  # Weekly backups of the external drive to another external drive via borg.
  systemd.timers."backup-elements" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Weekly on Sunday midnight.
      OnCalendar = "Sun 00:00";
      Persistent = true;
    };
  };
  systemd.services."backup-elements" = {
    script = ''
      #!${pkgs.bash}/bin/bash
      today=$(${pkgs.coreutils}/bin/date +"%Y-%m-%d")
      ${pkgs.coreutils}/bin/printf "\nNew Backup\n===========\nDate: ''${today}\n\n" >> /root/backup_elements.log
      ${pkgs.borgbackup}/bin/borg create \
        --verbose \
        --stats \
        /mnt/backup/borg::"elements-daily-''${today}" \
        /mnt/elements \
        /var/lib/transmission/.config/transmission-daemon \
        2>&1 | ${pkgs.coreutils}/bin/tee -a /root/backup_elements.log
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
