let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK9gaii6nSVqUOBYHPotGGBSBxoV6EHL1YFFoLzyJRIN";
  agenixPubkey = ../../id_ed25519_agenix.pub;
  keys = [key (builtins.readFile agenixPubkey)];
in {
  "tudor-password.age".publicKeys = keys;
}
