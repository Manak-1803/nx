{
  flake.modules.generic.terra = {
    specialisation.windows.configuration = {
      environment.etc."specialisation".text = "windows";
    };
  };
}
