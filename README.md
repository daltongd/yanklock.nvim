# 🔒 yanklock.nvim

## What is yanklock?

A simple plugin for [neovim](https://neovim.io/) that *temporarily* 'locks' the yank buffer used by the `paste` (`p` or `P`) command to `"0`, so that you can safely use commands like `d`, `c`, `x`, `s`, and their upper-case counterparts, or paste over text in the visual mode with `p` wile keeping the pasted contents to the last thing you yanked (`y`).

This plugin came to be from a basic need to avoid typing `"0p` every time I wanted to do a bunch of changes at once, this way they can be done quickly and without hesitating. The existing plugins didn't 'cut' it, I wanted a simpler and a completely reversible solution to keep the 'vanilla' vim motions for the most part, but have this functionality handy if I ever need it.

### Alternatives

First of all you may use `P` in the visual mode to paste over the selected text - this operation will not replace the contents of the `"` buffer. This basically solves it for the visual mode's select and replace.

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
  dir = "daltongd/yanklock.nvim",
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
  dir = "daltongd/yanklock.nvim",
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
  dir = "daltongd/yanklock.nvim",
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
