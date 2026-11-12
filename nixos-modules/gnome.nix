{ inputs, ... }: {
  flake.modules.nixos.gnome =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.gnome;
    in
    {
      options.rsnxmcst.gnome = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services = {
          desktopManager.gnome.enable = true;
          displayManager.gdm.enable = true;
        };

        environment = {
          gnome.excludePackages = with pkgs; [
            decibels
            epiphany
            gnome-calculator
            gnome-calendar
            gnome-clocks
            gnome-connections
            gnome-contacts
            gnome-logs
            gnome-maps
            gnome-music
            gnome-system-monitor
            gnome-text-editor
            gnome-tour
            gnome-user-docs
            gnome-weather
            loupe
            papers
            showtime
            simple-scan
            snapshot
            yelp
          ];

          systemPackages = with pkgs; [
            refine
            gnomeExtensions.caffeine
            gnomeExtensions.blur-my-shell
            gnomeExtensions.just-perfection
            gnomeExtensions.clipboard-indicator
            gnomeExtensions.alphabetical-app-grid
          ];
        };

        home-manager.sharedModules = [
          ({ config, ... }: {
            rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/dconf" ];
          })
        ];
      };
    };
}
