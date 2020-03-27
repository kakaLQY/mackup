# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    timeout = 2;
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/36b9ad1dbaaa79e0f6d74247b43e906e150b6d75.tar.gz;
      }))
    ];
  };

  # Without any `nix.nixPath` entry:
  nix.nixPath =
    # Prepend default nixPath values.
    options.nix.nixPath.default ++
    # Append our nixpkgs-overlays.
    [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ]
  ;
  nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  networking = {
    hostName = "nixos"; # Define your hostname.
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    enableIPv6 = false;
    defaultGateway = "192.168.1.1";
    nameservers = ["8.8.8.8" "114.114.114.114"];

    proxy = {
      default = "http://100.100.100.200:1081";
      noProxy = "127.0.0.1,192.168.1.1/24,100.100.100.251,localhost,internal.domain,.cn";
    };

    interfaces = {
      enp0s31f6.useDHCP = true;
      enp5s0.useDHCP = true;
      wlp6s0.ipv4.addresses = [
        {
          address = "192.168.1.150";
          prefixLength = 24;
        }
      ];
    };
  };

  # Configure network proxy if necessary

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
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
  time = {
    timeZone = "Asia/Hong_Kong";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      alacritty awscli bash byobu clojure direnv docker-compose docker-credential-helpers
      ec2_api_tools emacsGit exa fzf git gnumake
      ispell jq leiningen libsecret neovim
      nodejs-10_x nodePackages_10_x.npm nodePackages_10_x.serverless
      overmind pinentry-gnome polybarFull pstree ripgrep rxvt-unicode termite thunderbird tmux
      unzip vivaldi wget yarn yq zip
      (python37.withPackages(ps: with ps; [
        python-language-server boto3 virtualenv
      ]))
    ];
    variables = {
      EDITOR = "urxvt";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    gnupg.agent = { enable = true; enableSSHSupport = true; };
    fish.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock # lockscreen
        swayidle
        xwayland # for legacy apps
  waybar
      ];
    };
    seahorse.enable = true;
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.gnome3 = {
    gnome-keyring.enable = true;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound = {
    enable = true;
  };

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm = {
        enable = true;
      };
      defaultSession = "none+i3";
    };

    desktopManager = {
      xterm.enable = false;
      #gnome3.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3lock
      ];
    };

    layout = "us";
    xkbOptions = "ctrl:swap_lwin_lctl";

    videoDrivers = [ "amdgpu" ];
  };

  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.xmonad.enable = true;

  virtualisation = {
    docker.enable = true;
    virtualbox = {
      host = {
        enable = true;
  #     enableExtensionPack = true;
      };
      guest.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaka = {
    shell = "/run/current-system/sw/bin/fish";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "light" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
  };

  fonts.fonts = with pkgs; [
    source-han-sans-simplified-chinese source-han-serif-simplified-chinese
    unifont
    font-awesome
    jetbrains-mono
  ];

  #security = {
  #  pam.services.lightdm.enable = true;
  #};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
