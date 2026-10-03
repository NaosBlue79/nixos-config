{ config, lib, pkgs, ... }:

{

  programs.nixvim = {
    enable = true;

    opts = {
      number = true;
      relativenumber = true;
      smartindent = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      mouse = "a";
      clipboard = "unnamedplus";
      termguicolors = true;
    };

    extraPlugins = [
      pkgs.vimPlugins.catppuccin-nvim
    ];

    extraConfigLua = ''
      vim.opt.termguicolors = true
      require("catppuccin").setup({
        flavour = "mocha",
        transparent = true,
      })
      vim.cmd.colorscheme("catppuccin")
    '';

    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      treesitter.enable = true;
      neo-tree.enable = true;

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
        };
      };

      nvim-autopairs.enable = true;
      gitsigns.enable = true;
      indent-blankline.enable = true;

      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls.enable = true;
          ts_ls.enable = true;

          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };

        keymaps.lspBuf = {
          "gd" = "definition";
          "K" = "hover";
          "<leader>ca" = "code_action";
          "<leader>rn" = "rename";
        };
      };

      cmp = {
        enable = true;

        settings = {
          autoEnableSources = true;

          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];

          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
    };

    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };
}
