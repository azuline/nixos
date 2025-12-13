{ ... }:

{
  services.picom = {
    enable = true;
    backend = "egl";
    fade = true;
    fadeSteps = [
      0.05
      0.05
    ];
    fadeDelta = 1;
    vSync = true;
  };
}
