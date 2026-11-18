{
  flake.modules.generic.terra = {
    rsnxmcst.user-cain.enable = true;

    home-manager.users.cain = {
      rsnxmcst = {
        attic-client.enable = true;
        atuin.enable = true;
        bash.enable = true;
        btop.enable = true;
        discord.enable = true;
        fonts.enable = true;
        gh.enable = true;
        git.enable = true;
        impermanence.enable = true;
        prismlauncher.enable = true;
        secrets.enable = true;
        shell-tools.enable = true;
        spotify.enable = true;
        ssh.enable = true;
        vscodium.enable = true;
        xdg-directories.enable = true;
        zen-browser.enable = true;

        atuin.serverAddress = "https://atuin.rsnxmcst.dedyn.io";
      };
    };
  };
}
