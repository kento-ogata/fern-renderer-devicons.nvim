if exists('g:fern_renderer_nvim_devicons_loaded')
  finish
endif
let g:fern_renderer_nvim_devicons_loaded = 1

call extend(g:fern#renderers, {
      \ 'nvim_devicons': function('fern#renderer#nvim_devicons#new'),
      \})
