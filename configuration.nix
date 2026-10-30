{ config, pkgs, ... }:

{
  imports =
    [
        ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "C.UTF-8";
    LC_IDENTIFICATION = "C.UTF-8";
    LC_MEASUREMENT = "C.UTF-8";
    LC_MONETARY = "C.UTF-8";
    LC_NAME = "C.UTF-8";
    LC_NUMERIC = "C.UTF-8";
    LC_PAPER = "C.UTF-8";
    LC_TELEPHONE = "C.UTF-8";
    LC_TIME = "C.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "cz";
    variant = "";
  };

  console.keyMap = "cz-lat2";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

    #start
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  programs.firefox.enable = true;
  services.openssh.enable = true;
  programs.steam.enable = true;
  programs.partition-manager.enable = true;
  programs.git.enable = true;

  services.libinput.enable = true;
  environment.systemPackages = with pkgs; [
	neovim
	kitty
    klassy
	vim 
    fastfetch
    nerd-fonts.adwaita-mono   
    vesktop
    prismlauncher
    arduino-ide
    kdePackages.okular
    gimp
    uv
    pyright
    unzip
    gcc
    valgrind
];

  nix.settings.auto-optimise-store = true;
  programs.nh = {
  enable = true;
  clean = {
    enable = true;
    dates = "weekly";
    extraArgs = "--keep 5";
   };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."josef" = {
    isNormalUser = true;
    description = "josef";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
  };

  services.displayManager.autoLogin = {
   enable = true;
   user = "josef";
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80,8080,20 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "26.05"; 
}
