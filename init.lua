-- Bootstrap packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Core
  use 'nvim-lua/plenary.nvim'

  -- UI
  use { 'rose-pine/neovim', as = 'rose-pine' }
  use 'folke/zen-mode.nvim'

  -- Navigation
  use 'nvim-telescope/telescope.nvim'
  use 'ThePrimeagen/harpoon'
  use 'stevearc/oil.nvim'

  -- Git
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({ current_line_blame = true })
    end
  }

  -- LSP & Tooling
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'jay-babu/mason-null-ls.nvim'
  use 'nvimtools/none-ls.nvim'

  -- Autocomplete
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'

  -- Editing
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'mattn/emmet-vim'

  -- Markdown
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
    ft = { 'markdown' }
  }

  -- GitHub Copilot
  use { 'zbirenbaum/copilot.lua' }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- =====================
-- BASIC SETTINGS
-- =====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- =====================
-- KEYMAPS
-- =====================
vim.keymap.set('n', 'ff', ':Telescope find_files<CR>')
vim.keymap.set('n', 'tf', ':Telescope live_grep<CR>')
vim.keymap.set('n', 'tb', ':Telescope buffers<CR>')
vim.keymap.set('n', 'zm', ':ZenMode<CR>')
vim.keymap.set('n', '-', require('oil').open)

vim.keymap.set('n', '<C-e>', function()
  require('harpoon.ui').toggle_quick_menu()
end)

-- =====================
-- THEME
-- =====================
require("rose-pine").setup({ variant = "moon" })
vim.cmd("colorscheme rose-pine")

-- =====================
-- AUTOPAIRS
-- =====================
require('nvim-autopairs').setup()

-- =====================
-- COPILOT
-- =====================
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<Tab>",
    },
  },
})

-- =====================
-- CMP
-- =====================
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- =====================
-- LSP (Neovim 0.11+ native API)
-- =====================
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",
    "eslint",
    "html",
    "cssls",
    "jsonls",
    "tailwindcss",
    "graphql",
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- JavaScript / TypeScript
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

-- ESLint
vim.lsp.config("eslint", {
  capabilities = capabilities,
})

-- HTML
vim.lsp.config("html", {
  capabilities = capabilities,
})

-- CSS
vim.lsp.config("cssls", {
  capabilities = capabilities,
})

-- JSON
vim.lsp.config("jsonls", {
  capabilities = capabilities,
})

-- Tailwind CSS
vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
})

-- GraphQL
vim.lsp.config("graphql", {
  capabilities = capabilities,
})

-- Enable all LSP servers
vim.lsp.enable({
  "ts_ls",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "tailwindcss",
  "graphql",
})

-- =====================
-- FORMATTER (Prettier)
-- =====================
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
  },
})

require("mason-null-ls").setup({
  automatic_installation = true,
})



