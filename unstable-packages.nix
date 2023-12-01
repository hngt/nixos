{ config 
, lib 
, stdenv
, mygui
, pkgs
, cmake
, pkg-config
, boost
, freetype
, libuuid
, ois
, withOgre ? false
, ogre
, libGL
, libGLU
, libX11
, lz4
, Cocoa,
 ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
  mygui' = unstable.mygui.overrideAttrs (old: {
	version = "3.4.3";
	patches = [ ];
  src = pkgs.fetchFromGitHub {
    owner = "MyGUI";
    repo = "mygui";
    rev = "MyGUI3.4.3";
    hash = "sha256-s77RQwuwdbxeq7WrJWIVYvj6kYzQ7LKlLTmpjEgfu4o=";
  };
  buildInputs = old.buildInputs ++ [ lz4 ]; 
  });
  openmw = ( unstable.openmw.override {mygui=mygui';} ) ;
in {
  environment.systemPackages = with pkgs; [
    ( openmw.overrideAttrs ( old: {
    src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    rev = "13deb0fba8c7070f47b3402456207ab863885b94";
    sha256 = "sha256-s77RQwuwdbxeq7WrJWIVYvj6kYzQ7LKlLTmpjEgfu4o=";
  }; }
) )

  ];
}
