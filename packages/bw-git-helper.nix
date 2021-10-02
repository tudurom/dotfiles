# Shamelessly stolen from https://git.knightsofthelambdacalcul.us/hazel/etc/src/branch/canon/packages/bw-git-helper.nix
{ sources ? import ../nix/sources.nix
, pkgs, lib, buildGoModule, fetchFromGitHub }:
let
  spdx = lic: lic // {
    url = "https://spdx.org/licenses/${lic.spdxId}.html";
  };
in
buildGoModule rec {
  pname = "bw-git-helper";
  version = "unstable";

  src = sources.bw-git-helper;

  # not managed by niv
  vendorSha256 = "1x7iwd4ndcvcwyx8cxhkcwn5kwwf8nam47ln743wnvcrxi7q2604";

  buildInputs = with pkgs; [ bitwarden-cli ];

  meta = with lib; {
    description = "A git credential helper using BitWarden as a backend";
    homepage = "https://github.com/tudurom/bw-git-helper";
    license = spdx { spdxId = "EUPL-1.2"; };
    maintainers = [ maintainers.tudor ];
    platforms = platforms.all;
  };
}
