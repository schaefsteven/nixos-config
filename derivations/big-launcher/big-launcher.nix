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
      rev = "f8935c068b40c94610f3707c288675b2184558cb";
      sha256 = "sha256-T8kBHgSsBGmBR6Ro2No3P/PLQhzUogTz+b1b6eS7yjg=";
    })

#    (fetchzip {
#      name = "assets";
#      url = "https://github.com/complexlogic/big-launcher/files/10326572/assets.zip";
#      hash = "sha256-qYPvXTkhWKmZOuwrsQNIQbA7zOiqS4gdVsSnsXVdO6Y=";
#    })
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
    mkdir -p $out/bin
    cp big-launcher $out/bin
    ln -s /home/usr/.big-launcher/layout.xml $out/bin/layout.xml
    ln -s /home/usr/.big-launcher/config.ini $out/bin/config.ini
    ln -s /home/usr/.big-launcher/lconfig.h $out/bin/lconfig.h
    ln -s /home/usr/.big-launcher/assets $out/bin/assets
    # cp -r ../../assets/ $out/bin/
    runHook postInstall
  '';

}
