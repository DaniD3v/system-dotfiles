{
  description = "DaniD3v's system-dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    nixos-hardware,
    ...
  } @ inputs: let
    pathArrayIfExists = path:
      if builtins.pathExists path
      then [path]
      else [];

    generateConfig = hostname: system: inputs: modules: {
      "${hostname}" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules =
          [
            ({config, ...}: {
              nixpkgs.config.packageOverrides = previous: {
                unstable = import inputs.nixpkgs-unstable {
                  inherit system;
                  config = config.nixpkgs.config;
                };
              };
              networking.hostName = hostname;
            })
            ./hardware/${hostname}.nix
            ./common
          ]
          ++ pathArrayIfExists ./hosts/${hostname}.nix
          ++ modules;
      };
    };

    allowUnfree = {
      nixpkgs.config.allowUnfree = true;
      hardware.enableRedistributableFirmware = true;
    };

    stateVersion = version: {system.stateVersion = version;};
  in
    flake-utils.lib.eachDefaultSystem (
      system: {
        packages = {
          nixosConfigurations = generateConfig "rog-strix-g15" system inputs [
            ./common/networkmanager.nix
            ./common/guest-user.nix
            ./common/plymouth.nix
            ./common/pipewire.nix
            ./common/hyprland.nix
            ./common/nvidia.nix
            ./common/sddm.nix

            nixos-hardware.nixosModules.asus-rog-strix-g513im
            allowUnfree

            (stateVersion "24.05")
          ];
        };
      }
    );
}
