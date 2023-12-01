{ lib, stdenv, fetchFromGitHub, pkg-config, xorg }:

stdenv.mkDerivation {
  pname = "pokoy";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "ttygde";
    repo = "pokoy";
    rev = "v0.2.5";
    sha256 = "sha256-xw43AbdC5RlgLaihJAZsWht/gj+o7SfBEdI8y3OFsmw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with xorg; [
    libX11
    libxcb.dev
    xcbutil
    xcbutilkeysyms
    xcbutilwm
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A tiling window manager";
    homepage    = "https://github.com/ttygde/pokoy";
    maintainers = with maintainers; [ hngt ];
    license     = licenses.mit;
    platforms   = platforms.all;

    longDescription = ''
      spectrwm is a small dynamic tiling window manager for X11. It
      tries to stay out of the way so that valuable screen real estate
      can be used for much more important stuff. It has sane defaults
      and does not require one to learn a language to do any
      configuration. It was written by hackers for hackers and it
      strives to be small, compact and fast.
    '';
  };

}
