{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      attic-server.enable = true;
      atuin-server.enable = true;
      dbgate.enable = true;
      newt.enable = true;
      postgresql.enable = true;
      sshd.enable = true;
    };
  };
}
