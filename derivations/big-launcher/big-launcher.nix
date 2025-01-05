{
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  cmake,
  fetchFromGitHub,
  freetype,
  glib,
  harfbuzz,
  libtiff,
  libwebp,
  pcre2,
  pkg-config,
  stdenv,
  libxml2,
  inih,
  fmt,
  spdlog,
  libsndfile,
  libpulseaudio,
  alsa-lib,
  jack2,
  fetchzip,
}:

stdenv.mkDerivation {
  pname = "big-launcher";
  version = "pre-alpha";

  srcs = [ 
    (fetchFromGitHub {
      name = "main-repo";
      owner = "complexlogic";
      repo = "big-launcher";
      rev = "master";
      sha256 = "sha256-RbZ1VBdduFUVil6+Kv6ddVPY8Pa2amIvYLbnGtSLDYQ=";
    })

    (fetchzip {
      name = "assets";
      url = "https://github.com/complexlogic/big-launcher/files/10326572/assets.zip";
      hash = "sha256-qYPvXTkhWKmZOuwrsQNIQbA7zOiqS4gdVsSnsXVdO6Y=";
    })
  ];

  sourceRoot = "main-repo";

  buildInputs = [
    SDL2
    SDL2_image
    inih
    fmt
    spdlog
    SDL2_ttf
    SDL2_mixer
    libxml2
    cmake
    freetype
    glib
    harfbuzz
    libtiff
    libwebp
    pcre2
    pkg-config
    libsndfile
    libpulseaudio
    alsa-lib
    jack2
  ];

  buildPhase = ''
    runHook preBuild
    cmake ..
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/build
    cp launcher config.ini lconfig.h $out/build
    ln -s /home/usr/layout.xml $out/build/layout.xml
    ls -al
    cp -r ../../assets/ $out/build/
    runHook postInstall
  '';

}
