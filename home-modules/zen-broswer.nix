{ inputs, ... }: {
  flake.modules.homeManager.zen-browser =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.zen-browser;

      rayburstMessaging = pkgs.symlinkJoin {
        name = "rayburst-native-messaging";
        paths = [ pkgs.rayburst ];
        postBuild = ''
          mkdir -p $out/lib/mozilla/native-messaging-hosts
          cat > $out/lib/mozilla/native-messaging-hosts/dev.aninsomniacy.rayburst.json <<EOF
          {
            "name": "dev.aninsomniacy.rayburst.browser",
            "description": "Activate Rayburst",
            "path": "${pkgs.rayburst}/bin/rayburst-browser-launcher",
            "type": "stdio",
            "allowed_extensions": [
              "rayburst-connect@aninsomniacy.dev"
            ]
          }
          EOF
        '';
      };
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      options.rsnxmcst.zen-browser = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

          nativeMessagingHosts = [ rayburstMessaging ];

          policies = {
            DisablePocket = true;
            DisableAppUpdate = true;
            DisableTelemetry = true;
            OfferToSaveLogins = false;
            NoDefaultBookmarks = true;
            DisableFirefoxStudies = true;
            DisableFeedbackCommands = true;
            DontCheckDefaultBrowser = true;

            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
          };

          profiles.default = { };
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/zen/default" ];
      };
    };
}
