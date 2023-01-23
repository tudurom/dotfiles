{ ... }:
{
  imports = [
    ./cgit
    ./nginx.nix
    ./site.nix
    ./vaultwarden.nix
  ];
}
