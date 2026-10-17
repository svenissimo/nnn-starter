{pkgs, ...}: {
  # Enable niri from niri-flake. The module pulls in systemd units, polkit,
  # the screencast portal and sane session defaults.
  programs.niri.enable = true;
  # Use nixpkgs' package, not the niri-flake cache package.
  niri-flake.cache.enable = false;
  # Keep Niri and the system graphics drivers on the same locked package set.
  programs.niri.package = pkgs.niri;
  # Niri uses xwayland-satellite for X11 apps and starts it on demand.
  environment.systemPackages = [pkgs.xwayland-satellite];

  # Wayland portals: gnome backend for screencasting, gtk for file pickers.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
    };
  };
  systemd.user.services.niri-flake-polkit.enable = false;
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = pkgs.bibata-cursors;
      };
      appearance.hide_logo = true;
      appearance.scheme = "Synced";

      user.default = "nnn";
    };
  };
  # Brightness keys are handled by brightnessctl (installed in desktop.nix),
  # which talks to logind and needs no extra privileges in a session.
}
