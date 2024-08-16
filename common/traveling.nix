{lib, ...}: {
  nix.gc.automatic = lib.mkForce false;
  time.timeZone = lib.mkForce "Europe/Greece";
}
