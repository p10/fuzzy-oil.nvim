# fuzzy-oil.nvim

Seeach for a directory in [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) and open it in [oil.nvim](https://github.com/stevearc/oil.nvim).

## Installation

- [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'p10/fuzzy-oil.nvim',
  dependencies = { 'stevearc/oil.nvim', 'nvim-telescope/telescope.nvim' },
  cmd = 'FuzzyOil',
  opts = {},
}
```

default options https://github.com/p10/fuzzy-oil.nvim/blob/master/lua/fuzzy-oil/config.lua

## Usage

`:FuzzyOil`

---

Heavily inspired by [dir-telescope.nvim](https://github.com/princejoogie/dir-telescope.nvim)
