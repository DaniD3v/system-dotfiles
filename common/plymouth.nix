_: {
  boot = {
    plymouth.enable = true;

    # quiet boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];
  };
}
