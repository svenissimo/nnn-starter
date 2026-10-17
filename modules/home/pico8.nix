{config, ...}: {
  xdg.desktopEntries."pico-8" = {
    name = "PICO-8";
    comment = "Launch PICO-8";
    exec = "${config.home.homeDirectory}/pico-8/run_pico8.sh";
    icon = "${config.home.homeDirectory}/pico-8/lexaloffle-pico8.png";
    terminal = false;
    categories = ["Game"];
    settings.Path = "${config.home.homeDirectory}/pico-8";
  };
}
