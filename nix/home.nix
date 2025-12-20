{ config, pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    git
    neovim
    ripgrep
    fd
    jq
  ];
}

