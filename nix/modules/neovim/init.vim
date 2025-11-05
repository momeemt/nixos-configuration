set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set number relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set incsearch
set showmode
set hls

let mapleader = ","

inoremap <silent> jj <ESC>

noremap <Up> <Nop>
noremap! <Up> <Nop>
noremap <Down> <Nop>
noremap! <Down> <Nop>
noremap <Left> <Nop>
noremap! <Left> <Nop>
noremap <Right> <Nop>
noremap! <Right> <Nop>

function! OpenGoogleSearch()
  let word = expand('<cword>')
  let url = 'https://www.google.com/search?q=' . word
  execute "!open '" . url . "'"
endfunction

command! -nargs=0 Google :call OpenGoogleSearch()
nnoremap <leader>g :Google<CR>

augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N] ', a:dir)) =~? '^y\%[es]\%[s]?$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END
