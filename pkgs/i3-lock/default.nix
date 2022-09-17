{ pkgs }:

let
  make = i3lock-bin: pkgs.writeShellScriptBin "i3-lock" ''
    ${pkgs.xss-lock}/bin/xss-lock \
    --transfer-sleep-lock \
    -- \
        ${i3lock-bin} \
        --nofork \
        -i ~/backgrounds/lock.png \
        --inside-color=ffffff1c \
        --ring-color=ffffff3e \
        --line-color=ffffff00 \
        --keyhl-color=00000080 \
        --ringver-color=00000000 \
        --separator-color=22222260 \
        --insidever-color=0000001c \
        --ringwrong-color=00000055 \
        --insidewrong-color=0000001c \
        --verif-color=00000000 \
        --wrong-color=ff000000 \
        --time-color=00000000 \
        --date-color=00000000 \
        --layout-color=00000000 \
        --ring-width=15 \
        $@
  '';
in
{
  # Debian has non-standard @include directives in its PAM files that break the
  # standard PAM usage in Nix-compiled lockers. So in Non-NixOS systems,
  # i3lock-color must be installed from source.
  nixos = make "${pkgs.i3lock-color}/bin/i3lock-color";
  debian = make "/usr/bin/i3lock";
}
