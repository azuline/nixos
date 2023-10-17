{ pkgs, srcs, ... }:

let
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
        export NNN_OPTS=aAERx
        export NNN_COLORS=4532
        export NNN_FCOLORS=0a0b04010f07060c05030d09
        export NNN_TRASH=1
        export NNN_TMPFILE=$XDG_RUNTIME_DIR/nnn-lastd
        export NNN_PREVIEWDIR=/home/blissful/.cache/nsxiv
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
    extraPackages = with pkgs; [
      atool
      bat
      coreutils
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
    plugins = {
      mappings = {
        ";" = "preview-tui";
        f = "fzopen";
        i = "imgview";
        p = "playmusic";
      };
      # We vendor plugins in order to be able to add our own.
      src = ./plugins;
    };
    bookmarks = {
      a = "~/anime";
      b = "~/books";
      c = "~/cdrama";
      d = "~/downloads";
      f = "~/films";
      g = "~/manga";
      i = "~/images";
      k = "~/kpop";
      m = "~/music";
      t = "~/tv";
      v = "~/evergarden/visions";
    };
  };
}
