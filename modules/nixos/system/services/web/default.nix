{ ... }:
{
  imports = [
    ./cgit
    ./gitea.nix
    ./nginx.nix
    ./site.nix
    ./vaultwarden.nix
    ./yarr.nix
  ];
}
