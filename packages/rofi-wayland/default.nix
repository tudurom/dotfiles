{ stdenv, lib, fetchFromGitHub
, pkgconfig, libxkbcommon, pango, which, git, wayland-protocols
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check, meson, ninja, wayland }:
stdenv.mkDerivation rec {
  pname = "rofi-wayland-unwrapped";
  version = "unstable";

  # explicitly not niv-managed due to submodules
  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = "cef94af6e1397be6bb66d123599520378cc9366f";
    sha256 = "0dj7k4lvsj62l9vg01rmklhjfgvnms00vich9dgzmfwr64wxn1l9";
    fetchSubmodules = true;
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
    wayland-protocols wayland
  ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke ];
    platforms = with platforms; linux;
  };
}
