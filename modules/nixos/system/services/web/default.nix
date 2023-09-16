{ ... }:
{
  imports = [
    ./cgit
    ./gitea.nix
    ./miniflux.nix
    ./nginx.nix
    ./site.nix
    ./vaultwarden.nix
    ./yarr.nix
  ];
}
