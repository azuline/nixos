self: super: {
  nixGL = (
    super.callPackage "${builtins.fetchTarball {
      url = https://github.com/guibou/nixGL/archive/3ab1aae698dc45d11cc2699dd4e36de9cdc5aa4c.tar.gz;
      sha256 = "192k02fd2s3mfpkdwjghiggcn0ighwvmw0fqrzf0vax52v6l9nch";
    }}/nixGL.nix"
      {
        nvidiaVersion = "470.129.06";
      }
  ).nixGLDefault;
  nixGLBin = "${self.nixGL}/bin/nixGL";
}
