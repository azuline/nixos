{ ... }:

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
      merge.conflictStyle = "zdiff3";
      merge.tool = "vimdiff";
      pull.rebase = false;
      push.autoSetupRemote = true;
      push.default = "upstream";
      rebase.updateRefs = true;
      # Improve diffing.
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      diff.colorMovedWS = "allow-indentation-change";
      difftool.prompt = false;
      delta.features = "side-by-side line-numbers";
      delta.whitespace-error-style = "22 reverse";
      interactive.diffFilter = "delta --color-only";
      # Remember rebase confict resolution to re-apply in future.
      rerere.enabled = true;
      # Improve submodule handling.
      status.submoduleSummary = true;
      diff.submodule = "log";
      submodule.recurse = true;
      # Avoid data corruption:
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
    };
  };
}
