{
  flake.modules.homeManager.shell-tools =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.shell-tools;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.zoxide = {
          enable = true;
          options = [
            "--cmd cd"
            "--hook pwd"
          ];
        };

        home.sessionVariables = {
          _ZO_ECHO = "1";
          _ZO_RESOLVE_SYMLINKS = "1";
          _ZO_FZF_OPTS = "--height=40% --layout=reverse --border --no-multi --preview='ls -1 {}'";
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/zoxide" ];
      };
    };
}
