# Arsenal for development (which is rare nowadays). ;p
# If you're looking for text editors, go to `./editors.nix`.
{ config, lib, pkgs, ... }@attrs:

let cfg = config.profiles.dev;
in {
  options.profiles.dev = {
    enable =
      lib.mkEnableOption "basic set of programs for development setup";
    shell.enable =
      lib.mkEnableOption "enhanced shell configuration";
    extras.enable = lib.mkEnableOption "additional tools for development stuff";
    shaders.enable = lib.mkEnableOption "tools for developing shaders";
    servers.enable = lib.mkEnableOption "toolkit for managing servers from your home";
    funsies.enable = lib.mkEnableOption "installation of command-line applications for funsies";
    coreutils-replacement.enable = lib.mkEnableOption "replacement of coreutils with sane default options";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    ({
      home.packages = with pkgs; [
        cookiecutter # Cookiecutter templates for your mama (which is you).
        dasel # Universal version of jq.
        moar # More 'more'.
        perlPackages.vidir # Bulk rename for your organizing needs in the terminal.
      ];

      # Git interface for the lazy who cannot be asked to add hunks properly.
      programs.lazygit = {
        enable = true;
        settings = {
          gui = {
            expandFocusedSidePanel = true;
            showBottomLine = false;
            skipRewordInEditorWarning = true;
            theme = {
              selectedLineBgColor = [ "reverse" ];
              selectedRangeBgColor = [ "reverse" ];
            };
          };
          notARepository = "skip";
        };
      };

      # The file manager of choice.
      programs.lf = {
        enable = true;

        keybindings = {
          "<enter>" = "shell";
          "gr" = "cd /";
        };

        settings = {
          # Aesthetics.
          color256 = true;
          dircounts = true;
          hidden = true;
          drawbox = true;
          timefmt = "2006-01-02 15:04:05";

          # Scrolling options.
          wrapscroll = true;
          scrolloff = 10;
        };

        extraConfig = ''
          cmap <tab> cmd-menu-complete
          cmap <backtab> cmd-menu-complete-back
        '';
      };

      programs.tealdeer = {
        enable = true;
        settings = {
          display.use_pager = true;
          description = {
            foreground = "green";
            background = "black";
          };
          command.underline = true;
          updates.auto_update = false;
        };
      };

      # Echolocation. Since you're using a home-manager configuration, you're
      # most likely using Nix anyways.
      programs.nix-index.enable = lib.mkIf (attrs ? osConfig -> !attrs.osConfig.programs.nix-index.enable) true;
    })

    # Level up your terminal-dwelling skills with these.
    (lib.mkIf cfg.shell.enable {
      # A fuzzy finder that enables fuzzy finding not furry finding, a common misconception.
      programs.fzf =
        let
          fd = "${lib.getBin pkgs.fd}/bin/fd";
        in
        {
          enable = true;
          changeDirWidgetCommand = "${fd} --type directory --unrestricted";
          defaultCommand = "${fd} --type file --hidden";
        };

      # Supercharging your shell history. Just don't forget to flush them out
      # before doing questionable things.
      programs.atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          search_mode = "fuzzy";
          filter_mode = "global";
        };
      };

      # virtualenv but for anything else.
      programs.direnv = {
        enable = true;
        config.global = {
          load_dotenv = true;
          strict_env = true;
        };
        nix-direnv.enable = true;
      };

      # Learn teleportation in the filesystem.
      programs.zoxide.enable = true;

      # Some lazy bastard's shell prompt configuration.
      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          hostname = {
            ssh_only = false;
            trim_at = "";
          };
        };
      };
    })

    (lib.mkIf cfg.coreutils-replacement.enable {
      home.packages = with pkgs; [
        fd # Welp, a reliable find.
      ];

      # dog > sky dog > cat.
      programs.bat = {
        enable = true;
        config = {
          pager = "${lib.getBin pkgs.moar}/bin/moar";
          theme = "base16";
          style = "plain";
        };
      };

      # Your E last to the A.
      programs.eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };

      # RIP indeed to grep.
      programs.ripgrep = {
        enable = true;
        arguments = [
          "--max-columns-preview"
          "--colors=line:style:bold"
        ];
      };
    })

    (lib.mkIf cfg.extras.enable {
      home.packages = with pkgs; [
        gum # The fancy shell script toolkit.
        hyperfine # Making sure your apps are not just fine but REEEEEEAAAAALY fine.
        license-cli # A nice generator template for license files.
        quilt # Patching right up yer' alley.
        tokei # Stroking your programming ego by how many lines of C you've written.
        treefmt # I like the tagline of this tool: "One CLI for formatting your code tree." (It rhymes somewhat.)
        vhs # Declarative terminal tool demo.
        zenith # Very fanciful system dashboard.
      ];
    })

    (lib.mkIf cfg.shaders.enable {
      home.packages = with pkgs; [
        bonzomatic # Shadertoys for desktop bozos.
        shaderc # Make some seamless background loopy things.
      ];
    })

    (lib.mkIf cfg.servers.enable {
      home.packages = with pkgs; [
        bind.dnsutils # Make DNS a little less fun.
        kanidm # What is you?
        ipcalc # Calculate how many stars are there in space.
        geoip # Know where the spam came from.
        sshfs # Intrude others' home, why don't 'ya?
        whois # Doctor, are you not?
      ];
    })

    (lib.mkIf cfg.funsies.enable {
      home.packages = with pkgs; [
        fastfetch # Fetch, fast!
        asciiquarium-transparent # The closest thing to an actual aquarium (without the responsibility, of course).
        cowsay # Cow say "WHUT?"
        krabby # Kapture them Pikachus, bruh.
        lavat # Where the lava at?
      ];
    })
  ]);
}
