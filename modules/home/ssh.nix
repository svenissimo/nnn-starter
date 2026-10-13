{
  config,
  pkgs,
  ...
}: let
  onePassPath =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else "${config.home.homeDirectory}/.1password/agent.sock";
in {
  home.sessionVariables.SSH_AUTH_SOCK = onePassPath;

  # or, alternatively, set it in `.ssh/config` which has higher precedence:
  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host *
        IdentityAgent ${onePassPath}
    '';
  };
}
