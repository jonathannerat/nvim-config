# jonathannerat's Neovim dotfiles

You can install them by using the excellent utility [stow](https://github.com/AitorATuin/stow/tree/bug-56727) like so:

```sh
stow --dotfiles -v -t ~ stow/
```

Make sure you backup your `~/.config/nvim` or remove the previous symlinks there before running this, or you'll get a
warning from stow.

Also, there's currently [a bug](https://github.com/aspiers/stow/issues/33) in the main release of stow that prevents
folders like `dot-config` being translated to `.config`, so that's why I'm linking to AitorATuin's fork (and bugfix
branch).
