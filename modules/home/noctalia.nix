{
  lib,
  pkgs,
  inputs,
  ...
}: {
  # The Noctalia desktop shell: bar, launcher, notifications, control center,
  # lock screen and wallpaper, all in one. Colors follow Stylix.
  programs.noctalia = {
    enable = true;

    # Prebuilt package from noctalia.cachix.org (see modules/nixos/noctalia.nix).
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Run as a systemd user service tied to the graphical (niri) session so it
    # starts and stops with your login.
    systemd.enable = true;

    # Configure the shell interactively via its control center (Mod+Space →
    # settings) and, once you're happy, pin the values declaratively here under
    # `settings = { ... };` (schema at docs.noctalia.dev). Left at defaults so
    settings = {
      #bar.default.position = "bottom";
      shell = {
        ui_scale = 1.1;
        font_family = lib.mkForce "Maple Mono NF";
        polkit_agent = true;
      };
      bar.default = {
        background_opacity = 0.8;
        scale = 1.1;
      };

      theme = {
        # Stylix's Noctalia target sets this to "custom"; keep the selected community palette.
        source = lib.mkForce "community";
        community_palette = "Kanagawa Paper";
      };
      backdrop.enabled = true;

      plugins.enabled = [
        "oldirtty/color_picker"
"luochen1990/niri-ribbon"
      ];
      # plugins.autoupdate = "all";
    };
    # the build can't break on a settings key that doesn't exist yet.
  };
}
