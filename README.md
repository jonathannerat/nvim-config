# jonathannerat's Neovim dotfiles

To install this config, simply clone it to your Neovim config directory (make sure to backup your
current configs by running `test -d $HOME/.config/nvim && mv $HOME/.config/nvim{,.bak}`)

```sh
git clone https://github.com/jonathannerat/nvim-config $HOME/.config/nvim
```

Then you can run `:Lazy sync` to download all the plugins.

You can personalize the way plugins work by creating the file `lua/user/options/custom.lua` and
returning a table overriding an option in `lua/user/options/defaults.lua`. For example, if you use
`fd` to find files, you can add this to `custom.lua` to set the appropriate commands:

```lua
return {
   cmd = {
      find_files = { "fd", "-t", "f" },
      find_files_no_vcs = { "fd", "-t", "f", "--no-ignore-vcs" },
      find_all_files = { "fd", "-t", "f", "-t", "l", "-H", "--no-ignore-vcs" },
   },
```

In ubuntu, you probably wan to replace `fd` with `fdfind`.
