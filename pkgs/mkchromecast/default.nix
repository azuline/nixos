# vendored from e0464e4 of nixpkgs
# youtube-dl is dead, breaking build

{ lib
, stdenv
, fetchFromGitHub
, python3Packages
, sox
, flac
, lame
, wrapQtAppsHook
, ffmpeg
, vorbis-tools
, pulseaudio
, nodejs
, opusTools
, gst_all_1
, enableSonos ? true
, qtwayland
}:
let
  packages = [
    vorbis-tools
    sox
    flac
    lame
    opusTools
    gst_all_1.gstreamer
    nodejs
    ffmpeg
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ pulseaudio ];

in
python3Packages.buildPythonApplication {
  pname = "mkchromecast";
  version = "2024-06-02";

  src = fetchFromGitHub {
    owner = "muammar";
    repo = "mkchromecast";
    rev = "28a0ea89bf890e02c3742fbcb654159a93f58e0e";
    sha256 = "sha256-vRqxDtMSPFJoiWL3Bbycd81IO/R1GoJmmrwHaJrB9XE=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isLinux qtwayland;
  propagatedBuildInputs = with python3Packages; ([
    pychromecast
    psutil
    mutagen
    flask
    netifaces
    requests
    pyqt5
  ] ++ lib.optionals enableSonos [ soco ]);

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'platform.system() == "Darwin"' 'False' \
      --replace 'platform.system() == "Linux"' 'True'
  '';

  nativeBuildInputs = [ wrapQtAppsHook ];

  # Relies on an old version (0.7.7) of PyChromecast unavailable in Nixpkgs.
  # Is also I/O bound and impure, testing an actual device, so we disable.
  doCheck = false;

  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "--prefix PATH : ${lib.makeBinPath packages}"
  ];

  postInstall = ''
    substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/video.py \
      --replace '/usr/share/mkchromecast/nodejs/' '${placeholder "out"}/share/mkchromecast/nodejs/'
    substituteInPlace $out/share/applications/mkchromecast.desktop \
      --replace '/usr/bin/mkchromecast' '${placeholder "out"}/bin/mkchromecast' \
      --replace '/usr/share/pixmaps/mkchromecast.xpm' '${placeholder "out"}/share/pixmaps/mkchromecast.xpm'
    substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/systray.py \
      --replace '/usr/share/mkchromecast/images' '${placeholder "out"}/share/mkchromecast/images' \
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm 755 -t $out/bin bin/audiodevice
    substituteInPlace $out/${python3Packages.python.sitePackages}/mkchromecast/audio_devices.py \
      --replace './bin/audiodevice' '${placeholder "out"}/bin/audiodevice'
  '';

  meta = with lib; {
    homepage = "https://mkchromecast.com/";
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = licenses.mit;
    maintainers = with maintainers; [ shou ];
    mainProgram = "mkchromecast";
  };
}
