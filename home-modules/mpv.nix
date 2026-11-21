{ inputs, ... }: {
  flake.modules.homeManager.mpv =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.mpv;
    in
    {
      options.rsnxmcst.mpv = {
        enable = inputs.self.lib.enableOpt;
        enableNvidia = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.mpv = {
          enable = true;

          scripts = with pkgs.mpvScripts; [
            uosc
            thumbfast
          ];

          config = {
            vo = "gpu-next";
            gpu-api = "vulkan";
            gpu-context = "waylandvk";
            hwdec-codecs = "all";

            hwdec = if cfg.enableNvidia then "nvdec-copy" else "vaapi";
            vulkan-device = lib.mkIf cfg.enableNvidia "NVIDIA";

            profile = "high-quality";
            scale = "ewa_lanczossharp";
            cscale = "ewa_lanczossharp";
            dscale = "mitchell";
            correct-downscaling = true;
            linear-downscaling = true;
            sigmoid-upscaling = true;
            deband = true;
            deband-iterations = 2;
            deband-threshold = 35;
            deband-range = 16;

            target-colorspace-hint = true;
            tone-mapping = "bt.2446a";

            alang = "jpn,ja,eng,en";
            audio-channels = "auto-safe";
            audio-normalize-downmix = true;
            volume = 100;
            volume-max = 150;

            slang = "eng,en";
            sub-auto = "fuzzy";
            sub-font = "Inter Display";
            sub-font-size = 44;
            sub-border-size = 2.5;
            sub-shadow-offset = 1;
            sub-ass-override = "no";

            osc = false;
            osd-bar = false;
            border = false;
            keep-open = true;
            save-position-on-quit = true;
            watch-later-directory = "~/.local/state/mpv/watch_later";

            cache = true;
            demuxer-max-bytes = "512MiB";
            demuxer-max-back-bytes = "128MiB";
          };

          profiles = {
            "hdr-cinema" = {
              profile-cond = "p['video-params/primaries'] == 'bt.2020'";
              deband = false;
            };
          };

          bindings = {
            "WHEEL_UP" = "add volume 2";
            "WHEEL_DOWN" = "add volume -2";
            "Shift+RIGHT" = "no-osd seek 85";
            "Shift+LEFT" = "no-osd seek -85";
            "d" = "cycle deband";
            "h" =
              if cfg.enableNvidia then
                "cycle-values hwdec 'nvdec-copy' 'vaapi' 'no'"
              else
                "cycle-values hwdec 'vaapi' 'no'";
          };

          scriptOpts = {
            uosc = {
              timeline_style = "bar";
              timeline_size = 28;
              controls = "menu,gap,subtitles,<has_many_audio>audio,<has_many_video>video,<has_many_edition>editions,<stream>stream-quality,gap,space,speed,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen";
              top_bar = "always";
              top_bar_controls = "right";
              autoload = true;
            };

            thumbfast = {
              network = true;
              hwdec = true;
            };
          };
        };
      };
    };
}
