# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ callPackage, config, pkgs, options, ... }:

# let
#   babashka = pkgs.callPackage ./babashka.nix {};
# in

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_5_14;
    loader = {
      timeout = 3;
      systemd-boot = {
        enable = true;
        configurationLimit = 58;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Without any `nix.nixPath` entry:
  # nix.nixPath =
  #   # Prepend default nixPath values.
  #   options.nix.nixPath.default ++
  #   # Append our nixpkgs-overlays.
  #   [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ]
  # ;

  # nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  networking = {
    hostName = "nixos"; # Define your hostname.

    wireless = {
      enable = true;  # Enables wireless support via wpa_supplicant.
      interfaces = ["wlp4s0"];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    enableIPv6 = false;
    defaultGateway = "10.0.0.2";
    nameservers = ["8.8.8.8" "114.114.114.114"];

    # proxy = {
    #   default = "http://10.0.0.200:1081";
    #   noProxy = "127.0.0.1,192.168.1.1/24,10.0.0.1/24,localhost,internal.domain,.cn";
    # };

    interfaces = {
    # enp5s0.ipv4.addresses = [
    #   {
    #     address = "192.168.3.150";
    #     prefixLength = 24;
    #   }
    # ];
      wlp4s0.ipv4.addresses = [
        {
          address = "10.0.0.150";
          prefixLength = 24;
        }
      ];
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin uniemoji ];
    };
  };

  console = {
    # font = "JetBrainsMono";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      awscli2 bash bat bitcoind cacert certbot direnv exa fzf glibc
      git gnumake gnome3.adwaita-icon-theme
      jq libsecret lsof lshw pandoc mitmproxy
      overmind pavucontrol pinentry-gnome polybarFull pstree ripgrep scrot sqlite tmux
      tree unzip xclip wget yq zip
      zoom-us

      # Java & Clojure
      clojure jdk11 leiningen

      # Editor
      emacs27 vim neovim

      # Docker
      docker-compose docker-credential-helpers

      # Javascript
      nodejs nodePackages.javascript-typescript-langserver

      # Python
      (python38.withPackages(ps: with ps; [
        python-language-server virtualenv
      ]))

      # Term
      nushell termite xterm

      # browser
      vivaldi # firefox

      # Rust
      rustup

      # Dict
      (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))

      # Pass
      (pass.withExtensions (exts: with exts; [pass-otp pass-update pass-import]))
      zbar pwgen

      # IM
      slack discord

      # Network
      v2ray
    ];
    variables = {
      EDITOR = "termite";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs = {
    fish.enable = true;
    seahorse.enable = true;
    ssh.startAgent = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
    browserpass.enable = true;
    sway = {
      enable = false;
      extraPackages = with pkgs; [
        swaylock # lockscreen
        swayidle
        xwayland # for legacy apps
        waybar
      ];
    };
  };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    onedrive.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

  # nvidia.prime = {
  #   sync.enable = true;
  # };
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    dpi = 218;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "kaka";
      };
      lightdm.enable = true;
      defaultSession = "none+i3";
    };

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3lock
        i3blocks
        i3status
      ];
    };

    layout = "us";
    xkbOptions = "ctrl:swap_lwin_lctl,ctrl:nocaps,shift:both_capslock";

    videoDrivers = [ "amdgpu" ];
  };

  virtualisation = {
    docker.enable = true;
  # virtualbox = {
  #   host = {
  #     enable = true;
  #     enableExtensionPack = true;
  #   };
  #   guest.enable = false;
  # };
  };

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
    extraGroups = [ "wheel" "audio" "light" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
  };

  fonts.fonts = with pkgs; [
    font-awesome
    jetbrains-mono
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

