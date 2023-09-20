{ pkgs, srcs, ... }:

let
  runtimeDeps = with pkgs; [
    atool
    bat
    coreutils
    eza
    ffmpegthumbnailer
    file
    fontpreview
    glow
    gnome-epub-thumbnailer
    html2text
    imagemagick
    jq
    mediainfo
    mpv
    nsxiv
    p7zip
    poppler_utils
    unrar
    unzip
    w3m
  ];
  nnnWrapped = (pkgs.nnn.override {
    withPcre = true;
  }).overrideAttrs (old: {
    # Apply the:
    # - `cd on quit` logic
    # - configuration envvars
    # - default to cwd when no args are specified
    # We have to do this shitty hack postInstall in order to work with the
    # home-manager module.
    postInstall = old.postInstall + ''
      mv $out/bin/nnn $out/bin/.nnn-unwrapped
      cat - > $out/bin/nnn <<EOF
        #!${pkgs.bash}/bin/bash

        [ "''${NNNLVL:-0}" -eq 0 ] || {
          echo "nnn is already running"
          exit 0
        }
        export NNN_OPTS=aAdEgR
        export NNN_COLORS=4532
        export NNN_FCOLORS=0a0b04010f07060c05030d09
        export NNN_TRASH=1
        export NNN_TMPFILE=/home/blissful/tmp/.lastd
        $out/bin/.nnn-unwrapped "\''${@:-.}"
      EOF
      cat - >> $out/bin/nnn <<EOF
      [ ! -f "$NNN_TMPFILE" ] || {
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
      }
      EOF
      chmod +x $out/bin/nnn
    '';
  });
in
{
  programs.nnn = {
    enable = true;
    package = nnnWrapped;
    extraPackages = runtimeDeps;
    plugins = {
      mappings = {
        p = "preview-tui";
        f = "fzopen";
      };
      src = srcs.nnn-for-plugins + "/plugins";
    };
    bookmarks = {
      a = "~/atelier";
      b = "~/books";
      d = "~/downloads";
      f = "~/fonts";
      i = "~/images";
      k = "~/kpop";
      v = "~/evergarden/visions";
    };
  };
}
