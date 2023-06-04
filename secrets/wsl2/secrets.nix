let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFgsi5y8bJn4smX6xnDiQbGzSQGlZ6SrdCdf6hIMhCSF";
in
{
  "tudor-password.age".publicKeys = [ key ];
}
