{ config, pkgs, ... }:

{
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 12;
  nixpkgs.config.allowUnfree = true;

  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices.root = {
      device = "/dev/disk/by-uuid/c1bc2705-939f-4dc4-b6ce-6527192463a9";
      preLVM = true;
    };
    # Stuff for future passthrough. Not needed rn; tried to use it to fix another nvidia issue but it didn't solve it.
    # initrd.kernelModules = [
    #   "vfio_pci"
    #   "vfio"
    #   "vfio_iommu_type1"
    #   "vfio_virqfd"
    # ];
    # kernelParams = [
    #   "amd_iommu=on"
    #   "vfio-pci.ids=10de:2185,10de:1aeb,10de:1aec,10de:1aed"
    # ];
    # True by default; creates a warning when other parameters are unset. So we
    # disable it. See https://github.com/NixOS/nixpkgs/issues/254807.
    swraid.enable = false;
  };
  # virtualisation.spiceUSBRedirection.enable = true;

  fileSystems = {
    "/mnt/elements" = {
      device = "/dev/disk/by-uuid/01822c0a-0963-47b4-8f3c-a9765ea53093";
      fsType = "ext4";
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-uuid/09ca7108-e0de-4fc8-9cbf-86fee575bba3";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "splendor";
    networkmanager.enable = true;
    extraHosts = ''
    '';
  };

  time.timeZone = "America/New_York";
  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy ];
    };
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    # Load the larger console font earlier in the boot process.
    earlySetup = true;
    useXkbConfig = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager = {
      defaultSession = "none+i3";
      # It's fine to enable autologin since we have disk encryption.
      autoLogin = {
        enable = true;
        user = "blissful";
      };
      sessionCommands = ''
      '';
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
    screenSection = ''
      Option "metamodes" "DP-0: 3840x2160 +0+0 { ForceFullCompositionPipeline = On }, HDMI-0: 3840x2160 +3840+0 { ForceFullCompositionPipeline = On }"
    '';
    layout = "us";
    xkbOptions = "altwin:swap_lalt_lwin,caps:escape_shifted_capslock";
    videoDrivers = [ "nvidia" ];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    # The open source drivers don't work with the 1080Ti.
    open = false;
  };

  programs.dconf.enable = true;
  services.printing.enable = true;
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  users.users.blissful = {
    createHome = true;
    home = "/home/blissful";
    uid = 1000;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
  };

  environment = {
    interactiveShellInit = builtins.readFile ./bashrc;
    variables = {
      EDITOR = "nvim";
      XCURSOR_SIZE = "64";
    };
    systemPackages = with pkgs; [
      curl
      jq
      neovim
      networkmanagerapplet
      powertop
      git
      pciutils
      vim
      wget
      nftables
      wireguard-tools
    ];
  };

  virtualisation.docker.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  programs.seahorse.enable = true;
  services.tailscale.enable = true;
  programs.fish.enable = true;
  services.blueman.enable = true;
}
