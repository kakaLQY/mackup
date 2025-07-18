# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = 3;
      systemd-boot = {
        enable = true;
        configurationLimit = 50;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["electron-12.2.3"];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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
      interfaces = ["wlan0"];
    };

    extraHosts =
      ''
        192.168.31.170 ai
      '';
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    enableIPv6 = false;
    defaultGateway = "192.168.31.1";
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
      wlan0.ipv4.addresses = [
        {
          address = "192.168.31.170";
          prefixLength = 24;
        }
      ];
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "ibus";
      enable = true;
      ibus.engines = with pkgs.ibus-engines; [ libpinyin uniemoji ];
    };
  };

  console = {
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    homeBinInPath = true;
    systemPackages = with pkgs; [
      awscli2 bash bat bitcoind cacert certbot cloc direnv dpkg eza exiftool fasd fd file fzf glibc
      git gnumake adwaita-icon-theme jq libsecret lsof lshw pandoc
      overmind pavucontrol polybarFull pstree ripgrep scrot tmux
      tree unzip xclip wally-cli wget yq zip zoom-us zoxide

      # AppImage
      (appimage-run.override {
        extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
      })
      # Android
      # android-studio

      # Browser
      vivaldi firefox chromedriver chromium

      # Design
      freecad

      # Dict
      (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
      hunspell

      # Docker
      docker-compose docker-credential-helpers

      # Editor
      emacs vim neovim lazygit libreoffice-qt
      # unstable.code-cursor

      # Email
      mu isync

      # File manager
      ranger yazi ueberzugpp

      # IM
      slack discord

      # Java & Clojure
      clojure clojure-lsp jdk

      # Javascript
      nodejs nodePackages.typescript-language-server

      # Network
      v2ray

      # Pass
      (pass.withExtensions (exts: with exts; [pass-otp pass-update pass-import])) zbar pwgen

      # Term
      nushell termite xterm

      # Org Roam
      sqlite graphviz

      # Driver
      alsa-utils inxi glxinfo pciutils xorg.xdpyinfo
    ];
    variables = {
      EDITOR = "termite";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs = {
    adb.enable = true;
    # fish.enable = true;
    seahorse.enable = true;
    ssh.startAgent = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
    browserpass.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      setOptions = [ "HIST_FIND_NO_DUPS" ];
      shellAliases = {
        h = "cd ~";
        ll = "ls -l";
        lla = "ls -la";
        llf = "ls -l | fzf";
        llaf = "ls -la | fzf";
        rgf = "rg --files | fzf";
        e = "emacsclient -t";
      };
      histSize = 50000;
      ohMyZsh = {
        enable = true;
        plugins = [ "aws" "direnv" "fasd" "git" ];
        theme = "nanotech";
      };
    };
  };

  security.rtkit.enable = true;
  # List services that you want to enable:
  services = {
    blueman.enable = true;
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };
    journald.extraConfig = "SystemMaxUse=4G";
    openssh.enable = true;
    onedrive.enable = true;
    gnome.gnome-keyring.enable = true;
    nscd.enable = true;
    teamviewer.enable = false;
    udisks2.enable = true;
    pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
      wireplumber.extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };
    # ollama = {
    #   enable = true;
    #   acceleration = "rocm";
    #   loadModels = [ "deepseek-r1:7b" "deepseek-r1:8b" "deepseek-r1:14b" ];
    # };
    # open-webui = {
    #   enable = true;
    #   host = "0.0.0.0";
    #   port = 11111;
    # };
  };

  services.udev.extraRules = ''
    # VIA
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
    # CMSIS-DAP for microbit
    SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
  '';

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  hardware = {
    bluetooth.enable = true;
    keyboard.zsa.enable = true;
    graphics.enable = true;

    # nvidia.prime = {
    #   nvidiaBusId = "PCI:4:0:0";
    #   amdgpuBusId = "PCI:10:0:0";
    # };
  };

  # Enable the X11 windowing system.
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin = {
      enable = true;
      user = "kaka";
    };
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
    dpi = 223;
    displayManager.lightdm.enable = true;

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

    xkb = {
      layout = "us";
      options = "ctrl:swap_lwin_lctl,ctrl:nocaps,shift:both_capslock";
    };

    xrandrHeads = [
      {
        output = "DP-4";
        monitorConfig = ''
          Option "Rotate" "Left"
        '';
      }
      {
        output = "DP-5";
        primary = true;
        monitorConfig = ''
          Option "DPMS" "false"
          Option "RightOf" "DP-4"
        '';
      }
    ];

    videoDrivers = [ "modesetting" ];
  };

  virtualisation = {
    docker = {
      enable = true;
      # enableNvidia = true;
    };
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
  users = {
    defaultUserShell = pkgs.zsh;
    users.kaka = {
      isNormalUser = true;
      extraGroups = [ "wheel" "adbusers" "audio" "light" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    pkgs.nerd-fonts.symbols-only
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}

