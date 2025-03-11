_: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];

      # allow building from source
      fallback = true;

      # don't stop if a package fails building
      keep-going = true;

      # this should be the default.
      # see https://github.com/NixOS/nix/issues/11101
      preallocate-contents = true;

      # Useless warning.
      # My git tree is dirty 90% of the time I'm applying my configuration.
      warn-dirty = false;
    };

    optimise.automatic = true;
    gc.automatic = true;
  };
}
