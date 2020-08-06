# All of the command-line tools will be put here.
{ config, options, lib, pkgs, ... }:

with lib;
{
  imports = [
    ./base.nix
    ./git.nix
    ./lf.nix
    ./zsh.nix
  ];
}
