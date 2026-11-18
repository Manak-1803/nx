{
  flake.modules.generic.nocturne = {
    specialisation.windows.configuration = {
      environment.etc."specialisation".text = "windows";
    };
  };
}
