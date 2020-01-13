" Use Vim settings, rather than Vi settings
set nocompatible

" Read file when modified outside Vim
set autoread

" Do not keep any history
set viminfo='0,:0,<0,@0,f0
set nobackup
set nowb
set noswapfile

" Allow backspacing over everything in INSERT mode
set backspace=indent,eol,start

" Show ruler and command visual aid
set ruler
set showcmd

" Disable bells
set noerrorbells
set visualbell
set t_vb=

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in INSERT mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Set partial search and result highlighting
set incsearch
set hlsearch

" Ignore case when searching
set ignorecase
set smartcase

" Show matching bracets
set showmatch

" Highlight the cursor line
set cursorline

" Use Monaco as default font
set guifont=Monaco:h12

" Hide the toolbar in GUI
set guioptions-=T

" Set the colorscheme and window transparency
colorscheme desert
set transparency=5

" Disable 'command' and 'option' navigation bindings
if has("gui_macvim")
  let macvim_skip_cmd_opt_movement = 1
endif

" Change Netrw tree mode
let g:netrw_liststyle=3

" Set default vertical split to right
set splitright

" Set soft tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Indent
set ai
set si

" Show invisibles
set listchars=tab:▸\ ,trail:·
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Show line number and listchars
set list
set nu

set mouse=a
set wildmenu
set wildignore_=*.o,*.exe,*.swo,*.swp,*.obj

function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
  call DelTagOfFile(f)
  let resp = system(cmd)
  let resp = system(‘cscope -Rbq’)
  cs reset
endfunction
autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()
