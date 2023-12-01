{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpaidevel";
  version = "unstable-2023-11-18";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
#    rev = "1a5a19cf1f96ee06fac96d3f67c3441a9c5e3ec7";
#    sha256 = "sha256-q167og8S8YbLcREZ7DVbJhjMzx4iO0WgIFkOV2IpieM=";

    	rev = "21fcd224499af076398ab89e2602de58405c3acc";
    	sha256 = "sha256-iZDDbsyEJLyd33PCjW9XMNHinz8xqEfF4tll/boac9Y=";
  };

  vendorSha256 = "sha256-LuRbeHhdwzdTmlhGJ2TBC/8Zw8AnDGsWLdtHQzLthpY=";
  subPackages = [
    "cmd/senpai"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/senpai.1.scd > doc/senpai.1
    scdoc < doc/senpai.5.scd > doc/senpai.5
    installManPage doc/senpai.*
  '';

  meta = with lib; {
    description = "Your everyday IRC student";
    homepage = "https://sr.ht/~taiite/senpai/";
    license = licenses.isc;
  };
}
