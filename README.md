<div align="center">
 <h1>
  🔒 yanklock.nvim<br>
  <a href="https://github.com/daltongd/yanklock.nvim/actions/workflows/run_tests.yml"><img src="https://img.shields.io/github/actions/workflow/status/daltongd/yanklock.nvim/run_tests.yml?style=for-the-badge&logo=github&label=tests&labelColor=%23aa55aa"></a>
  <a href="https://github.com/daltongd/yanklock.nvim?tab=MIT-1-ov-file#readme"><img src="https://img.shields.io/github/license/daltongd/yanklock.nvim?style=for-the-badge&logo=opensourceinitiative"></a>
 </h1>
</div>

## What is yanklock?

A simple [Neovim](https://neovim.io/) plugin that *temporarily* 'locks' the yank register used by the `paste` (`p` or `P`) motions to `"0`, allowing you to safely use motions like `d`, `c`, `x`, `s`, and their uppercase counterparts, or paste over text in visual mode with `p`, while keeping the most recent yanked (`y`) content easily accessible.

This plugin was born out of a need to avoid typing `"0p` repeatedly when making a series of edits. I wanted a quicker, more efficient way to handle this process without hesitation. The existing plugins didn't 'cut' it, I was looking for a simpler and a completely reversible solution to keep the vanilla Vim motions for the most part, but have this functionality handy if I ever need it.

### Alternatives

First of all you may use `P` in the visual mode to paste over the selected text - this operation will not replace the contents of the `"` register. This basically solves it for the visual mode's select and replace.

There are some much more powerful plugins that improve the `yank` functionality, some of which can achieve a similar functionality. The one worth mentioning is [cutlass.nvim](https://github.com/gbprod/cutlass.nvim). Use it if you'd prefer to make this behavior permanent.

Other plugins that may interest you, some of which can achieve similar behavior:

- [yanky.nvim](https://github.com/gbprod/yanky.nvim)
- [nvim-miniyank](https://github.com/bfredl/nvim-miniyank)
- [yankbank-nvim](https://github.com/ptdewey/yankbank-nvim)

## Getting Started

### Installation

#### Using `init.lua`

With defaults

```lua
require('yanklock').setup()
```

With custom options

```lua
require('yanklock').setup({
  -- your options go here. see: ### Customization section in this readme
})
```

The plugin doesn't set any keymap by default, so to make it work you will have to add this line somewhere in your config (e.g. in `init.lua` or `keymaps.lua`)

```lua
vim.keymap.set("n", "<leader>yl", ":lua require('yanklock').toggle()<cr>", { desc = "yanklock toggle" })
```

#### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

Add a `plugins/yanklock.lua` file with these contents

```lua
return {
  "daltongd/yanklock.nvim",
  opts = {
    notify = true, -- optional
  },
  keys = {
    {
      "<leader>yl",
      function()
        require("yanklock").toggle()
      end,
      desc = "yanklock toggle",
    },
  },
}
```

Or add this to your `plugins.lua`

```lua
{
  "daltongd/yanklock.nvim",
  opts = {
    notify = true, -- optional
  },
  keys = {
    {
      "<leader>yl",
      function()
        require("yanklock").toggle()
      end,
      desc = "yanklock toggle",
    },
  },
},
```

Note: `opts = { notify = true }` is especially useful when paired with a notification plugin like [noice.nvim](https://github.com/folke/noice.nvim).

### Docs

To access more info about the available lua functions see:

```vim
:help yanklock
```

Note: if you're using [lazy.nvim](https://github.com/folke/lazy.nvim) to load the plugin, the help may not be available until it's loaded (used for the first time in the session).

### Usage

Toggle the lock on/off

```lua
:lua require('yanklock').toggle()
```

Locking

```lua
:lua require('yanklock').lock()
```

Unlocking

```lua
:lua require('yanklock').unlock()
```

### Customization

Defaults

```lua
{
  modes = { "n", "x" },
  notify = false,
}
```

- `modes`: select the modes that should be affected by the lock
- `notify`: choose whether you'd like to get notified about the state changes - especially useful when paired with a notification plugin like `noice.nvim`

Example config

```lua
{
  "daltongd/yanklock.nvim",
  opts = {
    modes = { "n", "x" },
    notify = true,
  },
  keys = {
    {
      "<leader>yl",
      function()
        require("yanklock").toggle()
      end,
      desc = "yanklock toggle",
    },
  },
},
```

Or in `init.lua`

```lua
require('yanklock').setup({
  modes = { "n", "x" },
  notify = true,
})
```

### Contributions

Contributions are more than welcome. If you have a problem with the plugin feel free to submit an issue.

### Acknowledgements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - a great inspiration, and a well written plugin I learned a lot from
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - an awesome set of tools, used by this plugin for it's testing framework
