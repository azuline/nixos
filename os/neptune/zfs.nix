{ ... }:

{
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    # Cap ARC at 4GB because I keep OOMing...
    kernelParams = [ "zfs.zfs_arc_max=4294967296" ];
  };
  # fileSystems."/galatea" = {
  #   device = "galatea";
  #   fsType = "zfs";
  # };
}
