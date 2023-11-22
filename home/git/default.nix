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
      core.pager = "delta";
      init.defaultBranch = "master";
      pull.rebase = false;
      push.default = "upstream";
      push.autoSetupRemote = true;
      merge.tool = "vimdiff";
      rebase.updateRefs = true;
      difftool.prompt = false;
      interactive.diffFilter = "delta --color-only";
      delta.features = "side-by-side line-numbers";
      delta.whitespace-error-style = "22 reverse";
    };
  };
}
