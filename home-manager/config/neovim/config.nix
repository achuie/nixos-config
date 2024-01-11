{ config, lib, pkgs, ... }:

# For problems with a given language server, run the following command on the path to the binary file from :LspLog
# `nix run nixpkgs\#patchelf -- --set-interpreter "$(nix eval nixpkgs\#stdenv.cc.bintools.dynamicLinker --raw)" /path/to/your/file`
{
  home.file = {
    ".config/nvim/init.lua".source = ./init.lua;
    ".local/share/nvim/nix/nvim-treesitter" = {
      recursive = true;
      source = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
    };
  };
  # Treesitter needs gcc; Mason needs cargo.
  home.packages = with pkgs; [ gcc cargo ];
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];
  };
}
