{ lib, fetchurl, stdenv }:

stdenv.mkDerivation rec {
  pname = "atarist";
  version = "1.0";
    name = "${pname}-${version}";
   otb = fetchurl {
    url = "https://u.sicp.me/eUB5B"; # URL to the converted OTB font
    sha256 = "0scv7yzyhq4kp4nsh4mkk4ajvwlzygla0qqns1fcalf51cqm6qxb";
    };
   dontUnpack = true;
  buildPhase = ''
    cp ${otb} atarist.otb
  '';
  installPhase = ''
    install -m 644 -D atarist.otb "$out/share/fonts/atarist.otb"
  '';

  meta = with lib; {
    description = "Atarist";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ wdavidw ];
  };
}


