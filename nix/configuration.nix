# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
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
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
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
      wlan0.ipv4.addresses = [
        {
          address = "10.0.0.170";
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
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    homeBinInPath = true;
    systemPackages = with pkgs; [
      awscli2 bash bat bitcoind cacert certbot cloc direnv dpkg exa exiftool fd file fzf glibc
      git gnumake gnome3.adwaita-icon-theme jq libsecret lsof lshw pandoc mitmproxy
      overmind pavucontrol pinentry-gnome polybarFull pstree ripgrep scrot tmux
      tree unzip xclip wally-cli wget yq zip zoom-us

      # AppImage
      (appimage-run.override {
        extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
      })
      # Android
      android-studio

      # Browser
      vivaldi firefox

      # Design
      freecad

      # Dict
      (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
      hunspell

      # Docker
      docker-compose docker-credential-helpers

      # Editor
      emacs vim neovim libreoffice-qt

      # Email
      mu isync

      # File manager
      ranger

      # IM
      slack discord

      # Java & Clojure
      clojure jdk11 leiningen

      # Javascript
      nodejs nodePackages.javascript-typescript-langserver

      # Network
      v2ray

      # Pass
      (pass.withExtensions (exts: with exts; [pass-otp pass-update pass-import])) zbar pwgen

      # Python
      (python39.withPackages(ps: with ps; [
        python-lsp-server virtualenv
      ]))

      # Term
      nushell termite xterm

      # Org Roam
      sqlite graphviz
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
    fish.enable = true;
    seahorse.enable = true;
    ssh.startAgent = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
    browserpass.enable = true;
  };

  # List services that you want to enable:
  services = {
    journald.extraConfig = "SystemMaxUse=4G";
    openssh.enable = true;
    onedrive.enable = true;
    gnome.gnome-keyring.enable = true;
    nscd.enable = true;
    teamviewer.enable = true;
    udisks2.enable = true;
  };

  services.udev.extraRules = ''
    # Vial
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
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

  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    keyboard.zsa.enable = true;

    # nvidia.prime = {
    #   nvidiaBusId = "PCI:4:0:0";
    #   amdgpuBusId = "PCI:10:0:0";
    # };

    # opengl = {
    #   driSupport32Bit = true;
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
    #
    # config = lib.mkForce ''
    #   Section "Files"

    #     FontPath "/nix/store/5yi2h0bd8rv7j2hncsi0cz1lc4pqha5n-unifont-14.0.01/share/fonts"
    #     FontPath "/nix/store/chv3dnpi3p6gs90yq32pjf22vanv7kps-font-cursor-misc-1.0.3/lib/X11/fonts/misc"
    #     FontPath "/nix/store/sc291h778q3r09qg0mmk03zkxh79059l-font-misc-misc-1.1.2/lib/X11/fonts/misc"
    #     FontPath "/nix/store/ijl2p5waslqmn08hxw845xn28nja7jfj-font-bh-lucidatypewriter-100dpi-1.0.3/lib/X11/fonts/100dpi"
    #     FontPath "/nix/store/lc4lk2kmliwgcrmvjxhs7kjrny3jxnl1-font-bh-lucidatypewriter-75dpi-1.0.3/lib/X11/fonts/75dpi"
    #     FontPath "/nix/store/90bmxnidzaryki1wrv279k991licp3p7-font-bh-100dpi-1.0.3/lib/X11/fonts/100dpi"
    #     FontPath "/nix/store/dgjb180mwc93prr3qlrlxb58wjdka418-font-adobe-100dpi-1.0.3/lib/X11/fonts/100dpi"
    #     FontPath "/nix/store/kqrzsyvmrmdim4njdsjjcw4l7m3y9qc7-font-adobe-75dpi-1.0.3/lib/X11/fonts/75dpi"
    #     ModulePath "/nix/store/d22xq6ic075q5ampv1dhs65qh3kr9fcl-xf86-video-amdgpu-21.0.0/lib/xorg/modules/drivers"
    #     ModulePath "/nix/store/d22xq6ic075q5ampv1dhs65qh3kr9fcl-xf86-video-amdgpu-21.0.0/lib/xorg/modules/drivers"
    #     ModulePath "/nix/store/cfssfgg5p432xqaap64ghm116kpfbvrs-nvidia-x11-495.44-5.15.29-bin/lib/xorg/modules/drivers"
    #     ModulePath "/nix/store/cfssfgg5p432xqaap64ghm116kpfbvrs-nvidia-x11-495.44-5.15.29-bin/lib/xorg/modules/extensions"
    #     ModulePath "/nix/store/7yii0wrh8mhxc57zdv9k911i27yykp56-xorg-server-1.20.13/lib/xorg/modules"
    #     ModulePath "/nix/store/7yii0wrh8mhxc57zdv9k911i27yykp56-xorg-server-1.20.13/lib/xorg/modules/drivers"
    #     ModulePath "/nix/store/7yii0wrh8mhxc57zdv9k911i27yykp56-xorg-server-1.20.13/lib/xorg/modules/extensions"
    #     ModulePath "/nix/store/hy4yakha9dk5jq233zhsvih1mza1r3vg-xf86-input-evdev-2.10.6/lib/xorg/modules/input"

    #   EndSection

    #   Section "ServerFlags"
    #     Option "AllowMouseOpenFail" "on"
    #     Option "DontZap" "on"
    #   EndSection

    #   Section "Module"

    #   EndSection

    #   Section "Monitor"
    #     Identifier "Monitor[0]"
    #   EndSection

    #   Section "Monitor"
    #     Identifier "DisplayPort-2"
    #     Option "Rotate" "left"
    #   EndSection

    #   Section "ServerLayout"
    #     Identifier "Layout[all]"
    #     Inactive "Device-nvidia[0]"

    #     # Reference the Screen sections for each driver.  This will
    #     # cause the X server to try each in turn.
    #     Screen "Screen-amdgpu[0]"
    #     Screen "Screen-amdgpu[1]"
    #   EndSection

    #   Section "Device"
    #     Identifier "Device-amdgpu[0]"
    #     Driver "amdgpu"
    #     BusID "PCI:10:0:0"
    #   EndSection

    #   Section "Device"
    #     Identifier "Device-nvidia[0]"
    #     Driver "nvidia"
    #     BusID "PCI:4:0:0"
    #   EndSection

    #   Section "Screen"
    #     Identifier "Screen-amdgpu[0]"
    #     Monitor    "Monitor[0]"
    #     Device "Device-amdgpu[0]"
    #     Option "RandRRotation" "on"
    #   EndSection

    #   Section "Screen"
    #     Identifier "Screen-amdgpu[1]"
    #     Monitor    "DisplayPort-2"
    #     Device "Device-amdgpu[0]"
    #     Option "RandRRotation" "on"
    #   EndSection
    # '';
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
  users.users.kaka = {
    shell = "/run/current-system/sw/bin/fish";
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "audio" "light" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
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
  system.stateVersion = "22.11"; # Did you read the comment?
}

