{ pkgs, inputs, vars, ... }:

let
  hm = inputs.home-manager.lib.hm;
in
{
  imports = [
    ../../modules/home-manager
  ];

  home.stateVersion = vars.stateVersion;
}
