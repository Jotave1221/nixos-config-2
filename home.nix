{ config, pkgs, ... }:
{
  home.username = "jotave";
  home.homeDirectory = "/home/jotave";
  services.dunst.enable = true;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    pkgs.fastfetch
    gh
    pavucontrol
    pamixer
    feh
    libnotify
    rofi
    alacritty
    dunst
    (pkgs.writeShellScriptBin "vol" ''
      case "$1" in
        up) ${pkgs.pamixer}/bin/pamixer -i 5 ;;
        down) ${pkgs.pamixer}/bin/pamixer -d 5 ;;
        mute) ${pkgs.pamixer}/bin/pamixer -t ;;
      esac
      vol=$(${pkgs.pamixer}/bin/pamixer --get-volume)
      if [ "$(${pkgs.pamixer}/bin/pamixer --get-mute)" = true ]; then
        msg="Mudo"
      else
        msg="Volume: $vol%"
      fi
      ${pkgs.libnotify}/bin/notify-send \
        -h string:x-dunst-stack-tag:volume \
        -h int:value:"$vol" "$msg"
    '')
  ];

  home.file."Pictures/wallpaper.jpeg".source = ./configs/wallpaper.jpeg;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "jotave1221";
    userEmail = "joaovitorkrugerdias@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  xdg.configFile."fastfetch/config.jsonc".source = ./configs/fastfetch.jsonc;

  xdg.configFile."oxwm/config.lua".source = ./configs/oxwm.lua;

  programs.home-manager.enable = true;

    programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
    };

    initExtra = ''

      fastfetch

      rebuild() {
        cd ~/nixos-config || return
        nix flake update
        git add .
        sudo nixos-rebuild switch --flake .#$(hostname) || return
        git commit -m "''${1:-update $(date +%F)}"
        git push
        cd - > /dev/null
      }
    '';
  };
}