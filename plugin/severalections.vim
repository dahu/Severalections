" Vim global plugin for manipulating several visual selections at once
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" License:	Vim License (see :help license)
" Location:	plugin/severalections.vim
" Website:	https://github.com/dahu/severalections
"
" See severalections.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help severalections

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

"if exists("g:loaded_severalections")
"      \ || v:version < 700
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
let g:loaded_severalections = 1

" Options: {{{1
if !exists('g:severalections_highlight')
  let g:severalections_highlight = 'Visual'
endif

" Maps: {{{1
xnoremap <Plug>severalections_push :<c-u>call severalections#push()<cr>

if !hasmapto('<Plug>severalections_push', 'v')
  xmap <unique><silent> <leader>v <plug>severalections_push
endif

" Commands: {{{1
command! -nargs=+ Severalections call severalections#iterate(<q-args>)
command! -nargs=0 SeveralectionsPrior call severalections#hist_pop()

" Autocommands: {{{1
augroup Severalections
  au!
  au BufNew,BufRead * call severalections#init()
augroup END

" Teardown: {{{1
" reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
