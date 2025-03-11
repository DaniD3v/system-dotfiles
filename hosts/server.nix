{pkgs, ...}: {
  users.users.notyou = {
    isNormalUser = true;
    extraGroups = ["wheel"];

    openssh.authorizedKeys.keyFiles = [../ssh_key.pub];
  };

  # basic tools
  environment.systemPackages = with pkgs; [
    helix
    btop
    git
  ];

  # static ip
  networking.interfaces."enp15s0".ipv4.addresses = [
    {
      address = "192.168.1.2";
      prefixLength = 24;
    }
  ];

  # forward ssh
  networking.firewall = {
    allowedTCPPorts = [22];
  };
}
