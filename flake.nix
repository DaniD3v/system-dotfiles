{
  description = "DaniD3v's system-dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:DaniD3v/nixpkgs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nixos-hardware,
    disko,
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

    container = name: container: {
      config.virtualisation.oci-containers.containers = {
        name = container;
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
          nixosConfigurations =
            generateConfig "rog-strix-g15" system inputs [
              ./common/networkmanager.nix
              ./common/logitech-g920.nix
              ./common/guest-user.nix
              ./common/plymouth.nix
              ./common/pipewire.nix
              ./common/hyprland.nix
              ./common/nvidia.nix
              ./common/sddm.nix

              nixos-hardware.nixosModules.asus-rog-strix-g513im
              allowUnfree

              (stateVersion "24.05")
            ]
            // generateConfig "server" system inputs [
              ./common/ssh.nix

              # (container ./container/vaultwarden.nix)

              disko.nixosModules.disko
              ./hardware/server.disko.nix

              (stateVersion "24.11")
            ];
        };
      }
    );
}
