{...}: {
  # completely disable drivers if commented
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # caused issues previously
    open = true;

    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
