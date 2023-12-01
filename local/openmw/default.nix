{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, cmake
, pkg-config
, wrapQtAppsHook
, SDL2
, CoreMedia
, VideoToolbox
, VideoDecodeAcceleration
, boost
, bullet
, ffmpeg
, libXt
, luajit
, lz4
, mygui
, openal
, openscenegraph
, recastnavigation
, unshield
, yaml-cpp
}:

let
  GL = "GLVND"; # or "LEGACY";
   # osg' = (openscenegraph.override { colladaSupport = true; });
  bullet' = bullet.overrideDerivation (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      "-DOpenGL_GL_PREFERENCE=${GL}"
      "-DUSE_DOUBLE_PRECISION=ON"
      "-DBULLET2_MULTITHREADING=ON"
    ];
  });

in
stdenv.mkDerivation rec {
  pname = "openmw";
  version = "0.49-devel";

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    rev = "13deb0fba8c7070f47b3402456207ab863885b94";
    sha256 = "sha256-s77RQwuwdbxeq7WrJWIVYvj6kYzQ7LKlLTmpjEgfu4o=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  # If not set, OSG plugin .so files become shell scripts on Darwin.
  dontWrapQtApps = stdenv.isDarwin;

  buildInputs = [
    SDL2
    boost
    bullet'
    ffmpeg
    libXt
    luajit
    lz4
    mygui
    openal
    openscenegraph
    recastnavigation
    unshield
    yaml-cpp
  ] ++ lib.optionals stdenv.isDarwin [
    CoreMedia
    VideoDecodeAcceleration
    VideoToolbox
  ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=${GL}"
    "-DOPENMW_USE_SYSTEM_RECASTNAVIGATION=1"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOPENMW_OSX_DEPLOYMENT=ON"
  ];

  meta = with lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "https://openmw.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar marius851000 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

