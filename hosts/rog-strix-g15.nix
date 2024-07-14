{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  boot = {
    # doesn't actually activate because the drivers aren't loaded with the kernel
    # this is still activated to disable the console output
    plymouth.enable = true;

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };

    tmp.useTmpfs = true;
  };

  networking = {
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false; # massivly improve boot time

  sound.enable = true;
  hardware = {
    cpu.amd.updateMicrocode = true;

    bluetooth.enable = true;
    opengl.enable = true;
  };

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      videoDrivers = ["amdgpu"];
    };

    displayManager = {
      sessionPackages = with pkgs.gnome; [gnome-session.sessions];

      sddm = {
        enable = true;
        package = pkgs.unstable.kdePackages.sddm;

        theme = "sddm-astronaut-theme";
        extraPackages = [pkgs.unstable.sddm-astronaut];

        wayland.enable = true;
      };
    };

    pipewire = {
      enable = true;

      pulse.enable = true;
      alsa.enable = true;
    };

    earlyoom.enable = true;
    upower.enable = true;
    asusd.enable = true;

    gvfs.enable = true; # nautilus fix
    sysprof.enable = true;
  };

  security = {
    pam.services.swaylock = {}; # fix swaylock
    rtkit.enable = true; # pipewire
  };

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";

      enableOnBoot = false;
    };
  };

  users.users = {
    notyou = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "video" "dialout"];
    };
    guest = {
      isNormalUser = true;
      hashedPassword = "";
    };
  };

  fonts.packages = [pkgs.meslo-lgs-nf];

  environment.systemPackages = with pkgs; [
    gnome.gnome-disk-utility
    gnome-text-editor
    gnome.nautilus
    libreoffice
    alacritty
    firefox

    docker-compose
    alejandra
    fastfetch

    btop
    git

    (unstable.sddm-astronaut.override {
      themeConfig = {
        ForceHideCompletePassword = true;
        FormPosition = "left";
        AccentColor = "#746385";
      };
    })
  ];

  programs = {
    steam.enable = true;

    hyprland.enable = true;
    dconf.enable = true;
    fish.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };

  users.defaultUserShell = pkgs.fish;

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk # gnome darkmode fix + file picker
    pkgs.xdg-desktop-portal-hyprland
  ];
}
