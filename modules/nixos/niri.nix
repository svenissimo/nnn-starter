{
  pkgs,
  config,
  ...
}: {
  # Enable niri from niri-flake. The module pulls in systemd units, polkit,
  # the screencast portal and sane session defaults.
  programs.niri.enable = true;
  # Use the Nixpkgs Niri package built with the same locked package set as the
  # system graphics drivers. The separately locked niri-flake package uses an
  # older glibc than this system's Mesa and fails to load its DRM backend.
  programs.niri.package = pkgs.niri;

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
  # Minimal graphical login: tuigreet drops you straight into a niri session.
  # Flip `services.greetd.settings.default_session.user` to your username and
  # set `initial_session` instead of `default_session` to autologin.
  # services.greetd = {
  #   enable = true;
  #   settings.default_session = {
  #     command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  #     user = "greeter";
  #   };
  # };
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
  # services.displayManager.noctalia-greeter = {
  #   enable = true;
  #   settings = {
  #     cursor.size = 24;
  #     keyboard.layout = "us";
  #   };
  #   cursorTheme = {
  #     package = pkgs.bibata-cursors;
  #     name = "Bibata-Modern-Ice";
  #   };
  # };
  # Brightness keys are handled by brightnessctl (installed in desktop.nix),
  # which talks to logind and needs no extra privileges in a session.
}
