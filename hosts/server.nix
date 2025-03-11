{pkgs, ...}: {
  users.users.notyou = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    helix
    btop
    git
  ];

  networking.interfaces."enp15s0".ipv4.addresses = [
    {
      address = "192.168.1.2";
      prefixLength = 24;
    }
  ];
}
