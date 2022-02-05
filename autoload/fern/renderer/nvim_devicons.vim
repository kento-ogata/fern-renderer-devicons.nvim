scriptencoding utf-8

let s:PATTERN = '^$~.*[]\'
let s:Config = vital#fern#import('Config')
let s:AsyncLambda = vital#fern#import('Async.Lambda')

let s:STATUS_NONE = g:fern#STATUS_NONE
let s:STATUS_COLLAPSED = g:fern#STATUS_COLLAPSED

function! fern#renderer#nvim_devicons#new() abort
  let default = fern#renderer#default#new()
  if !exists('g:nvim_web_devicons')
    call fern#logger#error("g:nvim_web_devicons not found. 'nvim_devicons' renderer requires 'kyazdani42/nvim-web-devicons'.")
    return default
  endif
  return extend(copy(default), {
        \ 'render': funcref('s:render'),
        \ 'syntax': funcref('s:syntax'),
        \ 'highlight': funcref('s:highlight'),
        \})
endfunction

function! s:render(nodes) abort
  let options = {
        \ 'leading': g:fern#renderer#nvim_devicons#leading,
        \ 'root_symbol': g:fern#renderer#nvim_devicons#root_symbol,
        \ 'leaf_symbol': g:fern#renderer#nvim_devicons#leaf_symbol,
        \ 'expanded_symbol': g:fern#renderer#nvim_devicons#expanded_symbol,
        \ 'collapsed_symbol': g:fern#renderer#nvim_devicons#collapsed_symbol,
        \}
  let base = len(a:nodes[0].__key)
  let Profile = fern#profile#start('fern#renderer#nvim_devicons#s:render')
  return s:AsyncLambda.map(copy(a:nodes), { v, -> s:render_node(v, base, options) })
        \.finally({ -> Profile() })
endfunction

function! s:syntax() abort
  syntax match FernLeaf   /^.*[^/].*$/ transparent contains=FernLeafSymbol
  syntax match FernBranch /^.*\/.*$/   transparent contains=FernBranchSymbol
  syntax match FernRoot   /\%1l.*/       transparent contains=FernRootText
  execute printf(
        \ 'syntax match FernRootSymbol /%s/ contained nextgroup=FernRootText',
        \ escape(g:fern#renderer#nvim_devicons#root_symbol, s:PATTERN),
        \)
  execute printf(
        \ 'syntax match FernLeafSymbol /^\%%(%s\)*%s/ contained nextgroup=FernLeafText',
        \ escape(g:fern#renderer#nvim_devicons#leading, s:PATTERN),
        \ escape(g:fern#renderer#nvim_devicons#leaf_symbol, s:PATTERN),
        \)
  execute printf(
        \ 'syntax match FernBranchSymbol /^\%%(%s\)*\%%(%s\|%s\)/ contained nextgroup=FernBranchText',
        \ escape(g:fern#renderer#nvim_devicons#leading, s:PATTERN),
        \ escape(g:fern#renderer#nvim_devicons#collapsed_symbol, s:PATTERN),
        \ escape(g:fern#renderer#nvim_devicons#expanded_symbol, s:PATTERN),
        \)
  syntax match FernRootText   /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernLeafText   /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernBranchText /.*\ze.*$/ contained nextgroup=FernBadgeSep
  syntax match FernBadgeSep   //         contained conceal nextgroup=FernBadge
  syntax match FernBadge      /.*/         contained
  setlocal concealcursor=nvic conceallevel=2
endfunction

function! s:highlight() abort
  highlight default link FernRootText     Comment
  highlight default link FernLeafSymbol   Directory
  highlight default link FernLeafText     None
  highlight default link FernBranchSymbol Statement
  highlight default link FernBranchText   Statement
endfunction

function! s:render_node(node, base, options) abort
  let level = len(a:node.__key) - a:base
  if level is# 0
    let suffix = a:node.label =~# '/$' ? '' : '/'
    return a:options.root_symbol . a:node.label . suffix . '' . a:node.badge
  endif
  let leading = repeat(a:options.leading, level - 1)
  let symbol = s:get_node_symbol(a:node)
  let suffix = a:node.status ? '/' : ''
  return leading . symbol . a:node.label . suffix . '' . a:node.badge
endfunction

function! s:get_node_symbol(node) abort
  if a:node.status is# s:STATUS_NONE
    let symbol = a:options.leaf_symbol . luaeval("require'nvim-web-devicons'.get_icon(_A[1],_A[2])",[a:node.label, fnamemodify(a:node.bufname, ":e")])
  elseif a:node.status is# s:STATUS_COLLAPSED
    let symbol = a:options.collapsed_symbol . ''
  else
    let symbol = a:options.expanded_symbol . ''
  endif
  return symbol . ' '
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'leading': ' ',
      \ 'root_symbol': '',
      \ 'leaf_symbol': '|  ',
      \ 'collapsed_symbol': '|+ ',
      \ 'expanded_symbol': '|- ',
      \ 'marked_symbol': '✓  ',
      \ 'unmarked_symbol': '   ',
      \})
