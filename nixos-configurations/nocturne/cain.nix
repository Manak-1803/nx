{
  flake.modules.generic.nocturne = {
    rsnxmcst.user-cain.enable = true;

    home-manager.users.cain = {
      rsnxmcst = {
        attic-client.enable = true;
        atuin.enable = true;
        bash.enable = true;
        btop.enable = true;
        discord.enable = true;
        fonts.enable = true;
        fragments.enable = true;
        gh.enable = true;
        git.enable = true;
        impermanence.enable = true;
        mpv.enable = true;
        prismlauncher.enable = true;
        rayburst.enable = true;
        secrets.enable = true;
        shell-tools.enable = true;
        spotify.enable = true;
        ssh.enable = true;
        vscodium.enable = true;
        xdg-directories.enable = true;
        zen-browser.enable = true;

        atuin.serverAddress = "http://10.18.238.151:8888";
        mpv.enableNvidia = true;
      };
    };
  };
}
