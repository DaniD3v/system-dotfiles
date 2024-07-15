{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs";
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
            ./common/nix-settings.nix
          ]
          ++ pathArrayIfExists ./hosts/${hostname}.nix
          ++ modules;
      };
    };

    stateVersion = {
      # stateVersion of all my current machines
      system.stateVersion = "24.05";
    };
  in
    flake-utils.lib.eachDefaultSystem (
      system: {
        packages = {
          nixosConfigurations = generateConfig "rog-strix-g15" system inputs [
            ./common/plymouth.nix
            ./common/nvidia.nix

            nixos-hardware.nixosModules.asus-rog-strix-g513im
            stateVersion
          ];
        };
      }
    );
}
