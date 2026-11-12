{ inputs, ... }: {
  flake.modules.homeManager.bash =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.bash;
    in
    {
      options.rsnxmcst.bash = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        home.shell.enableBashIntegration = true;

        programs.bash = {
          enable = true;
          enableCompletion = true;

          historyFile = "${config.xdg.dataHome}/bash/history";
          historyFileSize = 100000;

          historySize = 10000;
          historyControl = [
            "ignorespace"
            "erasedups"
          ];

          shellOptions = [
            "cdspell"
            "extglob"
            "dirspell"
            "globstar"
            "checkjobs"
            "histappend"
            "checkwinsize"
          ];
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/bash" ];
      };
    };
}
