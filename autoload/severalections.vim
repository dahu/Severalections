" Vim library for manipulating several visual selections at once
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" License:	Vim License (see :help license)
" Location:	autoload/severalections.vim
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

"if exists("g:loaded_lib_severalections")
"      \ || v:version < 700
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
let g:loaded_lib_severalections = 1

" Vim Script Information Function: {{{1
" Use this function to return information about your script.
function! severalections#info()
  let info = {}
  let info.name = 'severalections'
  let info.version = 1.0
  let info.description = 'Manipulate several visual selections at once.'
  let info.dependencies = []
  return info
endfunction

" Private Functions: {{{1

" Library Interface: {{{1

function! severalections#init()
  let b:severalections_history = []
  let b:severalections_positions = []
  let b:severalections_visuals = []
endfunction

function! severalections#clear()
  call add(b:severalections_history, b:severalections_positions)
  let b:severalections_positions  = []
  for v in b:severalections_visuals
    call matchdelete(v)
  endfor
  let b:severalections_visuals = []
endfunction

function! severalections#hist_pop()
  if len(b:severalections_history) == 0
    return
  endif
  let obj = remove(b:severalections_history, -1)
  for o in obj
    call severalections#markup(o)
  endfor
endfunction

function! severalections#push()
  let obj = [getpos("'<"), getpos("'>"), visualmode()]
  call severalections#markup(obj)
endfunction

function! severalections#markup(obj)
  let obj = a:obj
  let pat = '\%' . obj[0][1] . 'l\%' . obj[0][2] . 'c\_.*\%' . obj[1][1] . 'l\%' . obj[1][2] . 'c.'
  call add(b:severalections_positions , obj)
  call add(b:severalections_visuals, matchadd('Visual', pat))
endfunction

function! severalections#do(obj, commands, ...)
  let bang = a:0 ? a:1 : 0
  if setpos("'<", a:obj[0]) != 0
    throw "severalections#do: Error setting '<"
  endif
  if setpos("'>", a:obj[1]) != 0
    throw "severalections#do: Error setting '>"
  endif
  exe 'normal' . (bang ? '!' : '') . ' gv' . a:obj[2] . 'gv' . a:commands
endfunction

function! severalections#iterate(commands, ...)
  let bang = a:0 ? a:1 : 0
  let old_sel = &selection
  let &selection = 'old'
  for obj in b:severalections_positions
    try
      call severalections#do(obj, a:commands)
    catch
      echom 'severalections: Error setting visual mark'
      return
    endtry
  endfor
  call severalections#clear()
  let &selection = old_sel
endfunction

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
