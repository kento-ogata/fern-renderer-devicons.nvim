# 🌿 fern-renderer-devicons.nvim

[![fern renderer](https://img.shields.io/badge/🌿%20fern-plugin-yellowgreen)](https://github.com/lambdalisue/fern.vim)


[fern.vim](https://github.com/lambdalisue/fern.vim) plugin which add file type icons through [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons).

## Requreiments

- [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)
- Patched font
  - [Nerd Fonts](https://www.nerdfonts.com/)
  - [Cica](https://github.com/miiton/Cica)
  - [Others](https://github.com/ryanoasis/nerd-fonts#patched-fonts)

## Usage

Set `"nvim_devicons"` to `g:fern#renderer` like:

```vim
let g:fern#renderer = "nvim_devicons"
```

## See also

- [lambdalisue/fern-renderer-nerdfont.vim](https://github.com/lambdalisue/fern-renderer-nerdfont.vim)
