{vars, ...}: {
  imports = [
    ../../modules/home-manager
  ];

  home.stateVersion = vars.stateVersion;
}
