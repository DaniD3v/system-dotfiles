_: {
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../ssh_key.pub
  ];
}
