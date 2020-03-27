# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.enableIPv6 = false;
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = ["8.8.8.8" "114.114.114.114"];
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlp6s0.ipv4.addresses = [
    {
      address = "10.0.0.100";
      prefixLength = 24;
    }
  ];

  # Configure network proxy if necessary
  networking.proxy.default = "http://100.100.100.200:1081";
  networking.proxy.noProxy = "127.0.0.1,10.0.0.1,100.100.100.251,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [cloudpinyin];
    };
  };

  console = {
    font = "JetBrainsMono";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty awscli bash byobu clojure direnv docker emacs exa git
    ispell jq leiningen neovim nodejs
    overmind polybarFull postman pstree ripgrep rxvt-unicode thunderbird tmux
    unzip vivaldi wget yarn yq
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.fish.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      defaultSession = "none+i3";
    };

    desktopManager = {
      xterm.enable = false;
    };

    xkbOptions = "ctrl:swap_lwin_lctl";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
  rofi
  i3status
  i3lock
      ];
    };
  };
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaka = {
    shell = "/run/current-system/sw/bin/fish";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "light" ]; # Enable ‘sudo’ for the user.
  };

  fonts.fonts = with pkgs; [
    source-han-sans-simplified-chinese source-han-serif-simplified-chinese
    unifont
    jetbrains-mono
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}