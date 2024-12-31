{ pkgs, srcs, ... }:

let
  nnnWrapped = (pkgs.nnn.override {
    withPcre = true;
  }).overrideAttrs (old: {
    src = srcs.nnn-src;
    # Apply the:
    # - `cd on quit` logic
    # - configuration envvars
    # - default to cwd when no args are specified
    # We have to do this shitty hack postInstall in order to work with the
    # home-manager module.
    postInstall = old.postInstall + ''
      mv $out/bin/nnn $out/bin/.nnn-unwrapped
      # Echo the main script body without evaluating the script ('EOF' does
      # that). This way variables are preserved for real runtime.
      cat - > $out/bin/nnn <<'EOF'
        #!${pkgs.bash}/bin/bash

        [ "''${NNNLVL:-0}" -eq 0 ] || {
          echo "nnn is already running"
          exit 0
        }
        export NNN_OPTS=aAERx
        # Because nnn.nvim requires its own FIFO, we disable auto-FIFO when -F is passed.
        if [[ "$@" == *"-F1"* ]]; then
          export NNN_OPTS=AERx
        fi
        export NNN_COLORS=4532
        export NNN_FCOLORS=0a0b04010f07060c05030d09
        export NNN_TMPFILE="''${XDG_RUNTIME_DIR:=$HOME/.run}/nnn-lastd"
        export NNN_ORDER="V:$HOME/tunes/1. Releases - Added On;V:$HOME/tunes/1. Releases - Released On"
        # Dynamically set an order for every subdirectory in the following directories:
        export NNN_ORDER="$NNN_ORDER;$(${pkgs.findutils}/bin/find $HOME/images/ -mindepth 1 -maxdepth 1 -type d -printf 't:%p;' | ${pkgs.gnused}/bin/sed 's/;$//')"
        export NNN_ORDER="$NNN_ORDER;$(${pkgs.findutils}/bin/find $HOME/studies/ -type d -printf 'v:%p;' | ${pkgs.gnused}/bin/sed 's/;$//')"
        export NNN_ORDER="$NNN_ORDER;$(${pkgs.findutils}/bin/find $HOME/books/ -type d -printf 'v:%p;' | ${pkgs.gnused}/bin/sed 's/;$//')"
      EOF
      # And now echo the final program call but with evaluation (so that $out gets evaluated).
      cat - >> $out/bin/nnn <<EOF
        $out/bin/.nnn-unwrapped "\''${@:-.}"
      EOF
      cat - >> $out/bin/nnn <<'EOF'
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
    extraPackages = [
      # atool
      # bat
      # coreutils
      # ffmpegthumbnailer
      # file
      # fontpreview
      # glow
      # gnome-epub-thumbnailer
      # html2text
      # imagemagick
      # jq
      # mediainfo
      # mpv
      # nsxiv
      # p7zip
      # poppler_utils
      # unrar
      # unzip
      # w3m
    ];
    plugins = {
      mappings = {
        c = "copy-highlighted";
        f = "fzopen";
        i = "imgview";
        r = "rose";
      };
      # We vendor plugins in order to be able to add our own.
      src = ./plugins;
    };
    bookmarks = {
      b = "~/books";
      c = "~/tunes/3. Genres/Classical Music";
      d = "~/downloads";
      e = "/mnt/elements";
      i = "~/images";
      k = "~/tunes/3. Genres/K-Pop";
      K = "~/kpop";
      m = "~/tunes";
      M = "~/.music-source";
      p = "~/tunes/7. Playlists";
      s = "~/studies";
    };
  };
}
