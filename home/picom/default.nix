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
    opacityRules = [
      "95:class_g = 'Kitty' && !_NET_WM_STATE@:32a"
      "0:_NET_WM_STATE@[0]:32a = '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[1]:32a = '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[2]:32a = '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[3]:32a = '_NET_WM_STATE_HIDDEN'"
      "0:_NET_WM_STATE@[4]:32a = '_NET_WM_STATE_HIDDEN'"
    ];
  };
}
