_: {
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; # massivly improve boot time
}
