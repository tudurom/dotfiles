{ ... }:
{
  imports = [
    ./cgit
    ./gitea.nix
    ./nginx.nix
    ./site.nix
    ./vaultwarden.nix
    ./miniflux.nix
  ];
}
