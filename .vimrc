" Project-local Vim setup for Bluespec SystemVerilog (BSV).
"
" Use from the repository root:
"   vim -Nu .vimrc examples/01_counter/Counter.bsv
"
if exists('g:loaded_bsc_project_vimrc')
  finish
endif
let g:loaded_bsc_project_vimrc = 1

let s:project_root = fnamemodify(expand('<sfile>:p'), ':p:h')
let s:bsc_vim_runtime = s:project_root . '/vendor/bsc/util/vim'

if isdirectory(s:bsc_vim_runtime)
  execute 'set runtimepath^=' . fnameescape(s:bsc_vim_runtime)
else
  echohl WarningMsg
  echomsg 'BSC Vim syntax files are missing; run: make bootstrap'
  echohl None
endif

set nocompatible
filetype plugin indent on
syntax enable

set number
set hidden
set tabstop=3
set shiftwidth=3
set softtabstop=3
set expandtab
set makeprg=make

augroup bsc_project_vim
  autocmd!
  autocmd FileType bsv setlocal commentstring=//\ %s
  autocmd FileType bsv setlocal tabstop=3 shiftwidth=3 softtabstop=3 expandtab
  autocmd FileType bsv setlocal suffixesadd=.bsv
augroup END

" Project-level smoke command. It is intentionally opt-in: press <leader>c.
nnoremap <silent> <leader>c :make counter<CR>
