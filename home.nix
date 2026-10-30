{ pkgs, inputs, lib, ... }:
let
  # Copies a plasmoid folder from a source into the place Plasma looks
  mkPlasmoid = { id, src, subdir ? "." }:
    pkgs.runCommandLocal "plasmoid-${id}" { inherit src; } ''
      mkdir -p $out/share/plasma/plasmoids/${id}
      cp -r $src/${subdir}/. $out/share/plasma/plasmoids/${id}/
    '';

  compactPager = mkPlasmoid {
    id = "com.github.tilorenz.compact_pager";
    subdir = "package";
    src = pkgs.fetchFromGitHub {
      owner = "tilorenz";
      repo = "compact_pager";
      rev = "main";            # better: pin a commit hash
      hash = "sha256-q8s+eQAQJVYKMb0rprYdnYBRErYtJDQrLSdnQGzrr+U=";
    };
  };
 plasmusic = mkPlasmoid {
  id = "plasmusic-toolbar";
  subdir = "src";
  src = pkgs.fetchFromGitHub {
    owner = "ccatterina";
    repo = "plasmusic-toolbar";
    rev = "main";
    hash = "sha256-PLeJuI+T7lec/eF3ethBHbFq+5xFgi+ShmXPpt0Fono=";
  };
  };
in {
  imports = [
    ./plasma-config.nix
    inputs.areofyl-fetch.homeManagerModules.default
  ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    neovim
    powerline-go
    fzf
    compactPager
    plasmusic
  ];

  xdg.dataFile = {
    "icons/Reversal-pink-dark".source = ./themes/Reversal-pink-dark;
    "plasma/desktoptheme/my_custom".source = ./themes/my_custom;
  };

  programs.fetch = {
    enable = true;
    info = [
      "os" "kernel" "uptime" "shell" "display" "font"
      "terminal" "cpu" "memory" "swap" "disk"
    ];
    labelColor = "blue";
    speed = 1.0;
    spin = "xy";
  };

  xdg.configFile."autostart/lock-on-login.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Lock on login
    Exec=loginctl lock-session
    X-KDE-autostart-phase=1
  '';

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/bin" ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      sl = "ls";
      claer = "clear";
      clera = "clear";
      dc = "cd";
      "ůs" = "ls";
      skibidi = "ls";
    };

    initExtra = ''
      # User specific bashrc.d snippets
      if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
          if [ -f "$rc" ]; then
            . "$rc"
          fi
        done
      fi
      unset rc

      # powerline-go prompt
      function _update_ps1() {
        PS1="$(powerline-go -error $? -jobs $(jobs -p | wc -l))"
      }

      if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
        PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
      fi

      # fuzzy search with cd
      fcd() {
        local dir
        dir=$(find ~ -type d 2>/dev/null | fzf +m) && cd "$dir"
      }
    '';
  };
}
