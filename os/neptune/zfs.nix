{ ... }:

{
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
  };
  # fileSystems."/galatea" = {
  #   device = "galatea";
  #   fsType = "zfs";
  # };
}
