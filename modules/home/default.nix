{
  username,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./cli.nix
    ./zsh.nix
    ./starship.nix
    ./git.nix
    ./ghostty.nix
    ./neovim.nix
    ./zed.nix
    ./gtk.nix
    ./niri.nix
    ./noctalia.nix
    ./direnv.nix
    ./claude-code.nix
    ./apps.nix
    # Optional: comment out if PICO-8 is not installed at ~/pico-8 or you don't want its launcher.
    ./pico8.nix
    ./media.nix
    ./discord.nix
    ./1password.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.file = {
    "Pictures/Wallpapers/walls".source = inputs.walls;
    "Pictures/Wallpapers/wallpapers".source = inputs.makccr-wallpapers;
    "Pictures/Wallpapers/wallpaper.png".source = ../../themes/wallpaper.png;
  };

  # Match system.stateVersion in hosts/nnn/default.nix. Don't bump casually.
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
