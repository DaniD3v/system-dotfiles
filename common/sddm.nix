{pkgs, ...}: let
  sddm-astronaut = pkgs.unstable.sddm-astronaut.override {
    themeConfig = {
      AccentColor = "#746385";
      FormPosition = "left";

      ForceHideCompletePassword = true;
    };
  };
in {
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.unstable.kdePackages.sddm; # qt6 sddm version

    theme = "sddm-astronaut-theme";
    extraPackages = [sddm-astronaut];

    wayland.enable = true;
  };

  environment.systemPackages = [sddm-astronaut];
}
