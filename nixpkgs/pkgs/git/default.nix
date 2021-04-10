{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "blissful";
    userEmail = "blissful@sunsetglow.net";
    signing = {
      key = "953ACFC5F8F3E2E7";
      signByDefault = true;
    };
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "master";
      pull.rebase = false;
      push.default = "upstream";
    };
  };
}
