{ pin, ... }:

{
  users.users.transmission = { };
  services.transmission = {
    enable = true;
    package = pin.transmission_4;
    user = "transmission";
    group = "media";
    home = "/var/lib/transmission";
    openPeerPorts = true;
    openRPCPort = false;
    performanceNetParameters = true;
    credentialsFile = "/etc/nixos/os/neptune/transmission-credentials.json";
    settings = {
      alt-speed-enabled = false;
      alt-speed-time-enabled = false;
      announce-ip-enabled = false;
      bind-address-ipv4 = "192.168.1.207";
      bind-address-ipv6 = "::";
      blocklist-enabled = false;
      cache-size-mb = 4;
      download-limit-enabled = false;
      dht-enabled = false;
      download-dir = "/galatea/staging";
      download-queue-enabled = true;
      download-queue-size = 20;
      encryption = 1;
      idle-seeding-limit-enabled = false;
      incomplete-dir-enabled = false;
      lpd-enabled = false;
      message-level = 2;
      peer-congestion-algorithm = "";
      peer-id-ttl-hours = 6;
      peer-limit-global = 500;
      peer-limit-per-torrent = 50;
      peer-port = 56001;
      pex-enabled = false;
      preallocation = 1;
      prefetch-enabled = true;
      queue-stalled-enabled = true;
      queue-stalled-minutes = 10;
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
      speed-limit-down = 80000;
      speed-limit-down-enabled = true;
      speed-limit-up = 40000;
      speed-limit-up-enabled = true;
      start-added-torrents = true;
      tcp-enabled = true;
      torrent-added-verify-mode = "fast";
      trash-original-torrent-files = true;
      umask = 017;
      upload-limit-enabled = false;
      upload-slots-per-torrent = 15;
      utp-enabled = true;
      watch-dir = "/home/blissful/downloads/torrents";
      watch-dir-enabled = true;
    };
  };

  # The NixOS systemd service restricts writes to the explicitly configured
  # BindPaths.
  systemd.services.transmission.serviceConfig.BindPaths = [
    "/galatea"
    "/home/blissful/downloads/torrents"
  ];
}
