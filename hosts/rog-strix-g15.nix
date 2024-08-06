{pkgs, ...}: {
  boot = {
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

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = ["amdgpu"];
    };

    displayManager.sessionPackages = with pkgs.gnome; [gnome-session.sessions];

    earlyoom.enable = true;
    upower.enable = true;
    asusd.enable = true;

    gvfs.enable = true; # nautilus fix
    sysprof.enable = true;
  };

  security = {
    pam.services.swaylock = {}; # fix swaylock
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

    helix
    btop
    git
  ];

  programs = {
    steam.enable = true;

    hyprland.enable = true;
    dconf.enable = true;
    fish.enable = true;
  };

  users.defaultUserShell = pkgs.fish;

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk # gnome darkmode fix + file picker
    pkgs.xdg-desktop-portal-hyprland
  ];
}
