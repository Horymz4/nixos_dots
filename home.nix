{ pkgs, inputs, ... }: {
  imports = [ 
    ./plasma-config.nix
    inputs.areofyl-fetch.homeManagerModules.default
  ];

  home.stateVersion = "26.05";  # use the version you installed NixOS with

  home.packages = with pkgs; [
    neovim
    powerline-go
    fzf
    klassy
  ];

    xdg.dataFile = {
      "plasma/desktoptheme/MyStyle".source = ./themes/my_custom;

      "plasma/plasmoids/com.github.tilorenz.compact_pager".source =
        ./themes/com.github.tilorenz.compact_pager;
      "plasma/plasmoids/org.kde.olib.thermalmonitor".source =
        ./themes/org.kde.olib.thermalmonitor;
      "plasma/plasmoids/plasmusic-toolbar".source =
        ./themes/plasmusic-toolbar;
    };

  xdg.configFile."klassy/klassyrc".source = ./themes/klassyrc;
  programs.plasma.workspace.colorScheme = "BreezeDark"; 
  programs.plasma.workspace.widgetStyle = "Klassy";               #
  programs.plasma.workspace.wallpaper = ./themes/maze_linux2.png;   
  xdg.dataFile."icons/Reversal-pink-dark".source = ./themes/Reversal-pink-dark;
  programs.plasma.workspace.iconTheme = "Reversal-pink-dark";
  programs.plasma.workspace.windowDecorations = {
      library = "org.kde.klassy";
      theme = "Klassy";
  };

  #panels
  programs.plasma.panels = [
  {
    location = "bottom";
    height = 44;
    alignment = "center";     
    hiding = "dodgewindows";
    floating = true;
    lengthMode = "fit"; 
    widgets = [
      "org.kde.plasma.kickoff"
      "org.kde.plasma.pager"
      "org.kde.plasma.icontasks"
    ];
  }
  {
    location = "top";
    height = 28;
    lengthMode = "fill"; 
    widgets = [
      "com.github.tilorenz.compact_pager"  
      "org.kde.plasma.panelspacer"
      "org.kde.plasma.digitalclock"
      "org.kde.plasma.panelspacer"
      "org.kde.olib.thermalmonitor"
      "org.kde.plasma.systemtray"
      # {
      # }
      "org.kde.plasma.shutdownorswitch"
    ];
  }
  ];

  programs.fetch = {
    enable = true;
    info = [
        "os"
        "kernel"
        "uptime"
        "shell"
        "display"
        "font"
        "terminal"
        "cpu"
        "memory"
        "swap"
        "disk"
    ];
    labelColor = "blue";
    speed = 1.0;
    spin = "xy";
  };

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
