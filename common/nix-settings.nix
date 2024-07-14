_: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      # allow building from source
      fallback = true;

      # don't stop if a package fails building
      keep-going = true;

      # this should be the default.
      # see https://github.com/NixOS/nixpkgs/issues/327210
      preallocate-contents = true;

      # filesystem sync before assuming a path is valid.
      # this normally has a strong performance penalty but on (nvme) sdds it's fine
      sync-before-registering = true;

      # TODO set in dotfiles as well
      # maybe make a third flake containing common configurations for de-duplication?
      use-xdg-base-directories = true;

      # Useless warning.
      # My git tree is dirty 90% of the time I'm applying my configuration.
      warn-dirty = false;
    };

    optimise.automatic = true;
    gc.automatic = true;
  };
}
