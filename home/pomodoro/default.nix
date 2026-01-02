{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openpomodoro-cli
  ];

  home.file.".pomodoro/settings".text = ''
    default_pomodoro_duration=50
    default_break_duration=10
  '';
}
