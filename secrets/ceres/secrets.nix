let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOx1R1yElHBnKKcH3tPuuTZsRjHzWK8ztquIGvYxjY8f";
  agenixPubkey = ../../id_ed25519_agenix.pub;
  keys = [ key (builtins.readFile agenixPubkey) ];
in
{
  "tudor-password.age".publicKeys = keys;
  "yarr-credentials.age".publicKeys = keys;
  "dedyn.age".publicKeys = keys;
  "gitea-actions-token.age".publicKeys = keys;
  "attic-server-token.age".publicKeys = keys;
}
