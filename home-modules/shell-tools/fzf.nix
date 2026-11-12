{
  flake.modules.homeManager.shell-tools =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.shell-tools;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.fzf = {
          enable = true;
          defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
          defaultOptions = [
            "--height=40%"
            "--layout=reverse"
            "--border=rounded"
            "--info=inline"
          ];

          fileWidget = {
            command = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
            options = [ "--preview 'bat --color=always --style=numbers --line-range :500 {}'" ];
          };

          changeDirWidget = {
            command = "fd --type d --strip-cwd-prefix --hidden --exclude .git";
            options = [ "--preview 'eza --tree --level=2 --color=always {}'" ];
          };

          historyWidget.command = "";
        };
      };
    };
}
