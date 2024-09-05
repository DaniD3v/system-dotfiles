{pkgs, ...}: {
  boot.tmp.useTmpfs = true;
  hardware.bluetooth.enable = true;

  services = {
    xserver.videoDrivers = ["amdgpu"];

    # Tiny rescue gnome session if hyprland is bricked
    displayManager.sessionPackages = with pkgs.gnome; [gnome-session.sessions];

    earlyoom.enable = true;
    upower.enable = true;
    asusd.enable = true;
  };

  users.users = {
    notyou = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "dialout"];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565];
  };

  fonts.packages = [pkgs.meslo-lgs-nf];

  environment.systemPackages = with pkgs; [
    gnome.gnome-disk-utility
    gnome-text-editor
    gnome.nautilus
    alacritty
    librewolf

    fastfetch
    helix
    btop
    git
  ];

  programs = {
    steam.enable = true;
    fish.enable = true;
  };

  users.defaultUserShell = pkgs.fish;

  # fix gnome apps
  programs.dconf.enable = true;

  # fix nautilus
  services.gvfs.enable = true;

  # fix swaylock
  security.pam.services.swaylock = {};
}
