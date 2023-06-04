let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOx1R1yElHBnKKcH3tPuuTZsRjHzWK8ztquIGvYxjY8f";
in
{
  "tudor-password.age".publicKeys = [ key ];
}
