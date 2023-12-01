# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ darwin, lib, config, pkgs, ... }:
let
  atarist = pkgs.callPackage ./local/atarist.nix {  };
  pokoy = pkgs.callPackage ./local/pokoy.nix {  };
  # openmwdev = pkgs.libsForQt5.callPackage ./local/openmw { inherit (darwin.apple_sdk.frameworks) CoreMedia VideoDecodeAcceleration VideoToolbox;};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./private/opensmptd.nix # lmao
      ./hardware-configuration.nix
      # ./unstable-packages.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.vg0.device="/dev/disk/by-uuid/81a2ba1b-483f-4032-a51d-081008e298fb";

  networking.hostName = "balmora"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    nameservers = [ "127.0.0.1" "9.9.9.9"  ];
    networkmanager.dns = "none";
  };
# networking.resolvconf.enable = pkgs.lib.mkForce false;
#networking.dhcpcd.extraConfig = "nohook resolv.conf";
services.dnsmasq.enable = true;
services.dnsmasq.alwaysKeepRunning = true;
services.dnsmasq.settings.server = [ "9.9.9.9" "149.112.112.112" "208.67.222.222" "62.141.58.13" ];
services.dnsmasq.settings.cache-size = "500";
networking.hostFiles = [
(pkgs.fetchurl { url = "https://someonewhocares.org/hosts/zero/hosts"; sha256="sha256-B68SpfrTo++OpqtctPBreHNJ5Ms18lIzts9CX9FuuB0="; /* ... */ })
 ];
#services.resolved = {
#  enable = true;
#  domains = [ "~." ];
#  fallbackDns = [ "9.9.9.9" "149.112.112.112"  "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
#  #extraConfig = ''
#  #  DNSOverTLS=yes
#  #'';
#};


  # Set your time zone.
  time.timeZone = "Europe/London";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
  #   keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
   };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.spectrwm.enable = true;

  # fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    atarist
    dejavu_fonts
    terminus_font
    inter
  ];


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
  };
  services.getty.autologinUser = "user";
  # Enable CUPS to print documents.
  # services.printing.enable = true;
# services.pcscd.enable = true;
  programs.zsh.enable = true;
  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  sound.enable = true;
 services = {
    syncthing = {
        enable = true;
        user = "user";
        configDir = "/home/user/.config/syncthing/";   # Folder for Syncthing's settings and keys
    };
    };

  services.xserver.libinput.enable = true;
programs.i3lock.enable = true;
programs.xss-lock.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     shell = "${pkgs.zsh}/bin/zsh";
     packages = with pkgs; [
        borgbackup
	pokoy
	udiskie
	acpi
	aerc
	arandr
	atool
	autoconf
	automake
	autossh
	bison
	bsdgames
	chromium
	cmake
	cmus
	coreutils
	dash
	# DEVEL
	dig
	dmenu
	dunst
	ffmpeg
	findutils
	flex
	gawk
	gcc
	git
	gnumake
	go
	gzip
	htop
	imagemagick
	isync
	keepassxc
	less
	librewolf
	libtool
	lynx
	mpv
	neofetch
	neovim
	nnn
	notmuch
	openssl
	palemoon-bin
	patch
	pavucontrol
	picom
	pkg-config
	pkgs.xbanish
	playerctl
	pulsemixer
	rxvt-unicode
	sct
	slock
	slop
	smu
	stow
	stow
	usbutils
	telegram-desktop
	tmux
	tree
	unzip
	weechat
	which
	wmctrl
	xclip
	xfce.xfce4-terminal
	xlockmore
	xterm
	yt-dlp
	zathura
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  (st.overrideAttrs (oldAttrs: rec {
    # Using a local file
    configFile = writeText "config.def.h" (builtins.readFile ./local/st/config.h);
    # Or one pulled from GitHub
    # configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner = "LukeSmithxyz"; repo = "st"; rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b"; sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag"; }}/config.h");
    postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
  }))
     vis
	pinentry-curses
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     curl
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
pinentryFlavor = "gtk2";
     enableSSHSupport = true;
   };

  # List services that you want to enable:
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.udisks2.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ self.mpvScripts.mpris ];
	};
#      senpai = super.senpai.overrideAttrs (old: {
#      	version = "0.2.1";
#	src = super.fetchFromSourcehut {
#    		owner = "~taiite";
#    		repo = "senpai";
#    	rev = "1a5a19cf1f96ee06fac96d3f67c3441a9c5e3ec7";
#    	sha256 = "sha256-DRPnq3DJkeSRaPp3zopCjd3731y4C7ULDNvKI7j2RoQ=";
#  };
#      });

#        openmw = super.openmw.overrideAttrs (old: {
#            version = "0.49";
#	    patches =  [ ];
#
#            src = super.fetchFromGitHub {
#              owner = "OpenMW";
#              repo = "openmw";
#              rev = "13deb0fba8c7070f47b3402456207ab863885b94";
#              #    sha256 = lib.fakeSha256;
#              sha256 = "sha256-s77RQwuwdbxeq7WrJWIVYvj6kYzQ7LKlLTmpjEgfu4o=";
#            };
#
#  buildInputs = oldAttrs.buildInputs;
#          });
    })
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

}
