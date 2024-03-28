{lib, ...}:
with lib; {
  imports = [
    ./bash.nix
    ./fish.nix
    ./nushell.nix
    ./starship.nix
    ./zoxide.nix
  ];

  options = {
    homeModules.shell.default = {
      package = mkOption {
        type = with types; nullOr package;
        default = null;
        example = "pkgs.bash";
        description = "The shell to use when launching a terminal";
      };

      flags = mkOption {
        type = with types; listOf str;
        default = ["-l"];
        description = "List of flags to call the default shell with. Defaults to -l to start as login shell.";
      };
    };
  };
}
