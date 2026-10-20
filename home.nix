{ config, pkgs, ... }:
{
  home.username = "jotave";
  home.homeDirectory = "/home/jotave";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    pkgs.fastfetch
  ];

  programs.git = {
    enable = true;
    userName = "jotave1221";
    userEmail = "joaovitorkrugerdias@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.home-manager.enable = true;

    programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
    };

    initExtra = ''
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