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
elseif filereadable(expand('~/.vim/syntax/bsv.vim'))
  " Installed by scripts/install-vim-support.sh; ~/.vim is already in runtimepath.
else
  echohl WarningMsg
  echomsg 'BSC Vim syntax files are missing; run: make bootstrap and install-vim-support.sh'
  echohl None
endif

filetype plugin indent on

augroup bsc_project_vim
  autocmd!
  autocmd FileType bsv setlocal syntax=bsv commentstring=//\ %s
  autocmd FileType bsv setlocal tabstop=3 shiftwidth=3 softtabstop=3 expandtab
  autocmd FileType bsv setlocal suffixesadd=.bsv
  autocmd FileType bsv setlocal makeprg=make
  autocmd FileType bsv nnoremap <buffer> <silent> <leader>c :make counter<CR>
augroup END
