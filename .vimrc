execute pathogen#infect()
execute pathogen#helptags()

" Options {{{

set nocompatible
syntax on
filetype plugin indent on

set autoread
set autowrite
set backspace=2
set belloff=all
set clipboard=unnamed
set cmdheight=2
set encoding=utf-8
set expandtab
set fileformats=unix,dos

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

set history=1000
set hlsearch
set incsearch
set laststatus=2
set lazyredraw
set list
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
    let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
    let &fillchars = "vert:\u259a,fold:\u00b7"
else
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
set modelines=5
set mouse=a
set nowrap
set pastetoggle=<C-p>
set report=0
set ruler
set scrolloff=1
set smarttab
set shiftround
set shiftwidth=4
set shortmess+=I
set showcmd
set showmode
set showmatch
set smartcase
set smarttab
set softtabstop=4
set spellfile=~/.vim/spell/dict.utf-8.add
set spelllang=en,el
set tabstop=4
set t_ti= t_te= " Don't use alternate screen
set timeout timeoutlen=1000 ttimeoutlen=100 " Fix slow O inserts
set title
set ttyfast
set viminfo='100,\"1000
set wildignore+=.git,.hg,.svn
set wildignore+=*.o,*.pyc,*.so
set wildignore+=*.png,*.jpg,*.jpeg,*.gif
set wildignore+=.DS_Store
set wildignore+=*.orig
set wildmenu
set wildmode=longest:full,full

" }}}

" Autocommands {{{

" Resize splits when the window is resized
autocmd VimResized * :wincmd =

" Jump to the last position when reopening a file
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g'\"" |
            \ endif

augroup ft_text
    autocmd!
    autocmd BufNewFile,BufRead *.txt,README,INSTALL,NEWS,TODO
                \ if &filetype == "" |
                \   set ft=text |
                \ endif
    autocmd FileType text setlocal spell fo=tcwan1 tw=78
augroup END

augroup ft_mail
    autocmd!
    autocmd FileType mail setlocal spell fo=tcwan1
augroup END

augroup ft_prog
    autocmd!
    autocmd FileType python,ruby setlocal cc=80
    autocmd FileType c,cpp,java,go setlocal cc=80
    autocmd FileType javascript,python,ruby,sh,zsh,go setlocal ai
    autocmd FileType c,cpp,java setlocal ci
augroup END

augroup ft_python
    autocmd!
    autocmd FileType python setlocal makeprg=flake8\ %:S
augroup END

augroup ft_ruby
    autocmd!
    autocmd BufNewFile,BufRead Capfile,Rakefile,Vagrantfile setlocal ft=ruby
    autocmd FileType ruby setlocal sts=2 sw=2 ts=2
augroup END

augroup ft_vim
    autocmd!
    autocmd FileType vim setlocal fdm=marker
augroup END

augroup ft_markdown
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.mkd setlocal ft=markdown
    autocmd FileType markdown setlocal spell tw=78
augroup END

augroup ft_make
    autocmd!
    autocmd! FileType make setlocal noet ts=8 sw=8
augroup END

" http://vim.wikia.com/wiki/Encryption#GPG
augroup encrypted
    au!

    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre *.gpg set viminfo=
    " We don't want a various options which write unencrypted data to disk
    autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup

    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre *.gpg set bin
    autocmd BufReadPre,FileReadPre *.gpg let ch_save=&ch|set ch=2
    " (If you use tcsh, you may need to alter this line.)
    autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg2 --decrypt 2> /dev/null

    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost *.gpg set nobin
    autocmd BufReadPost,FileReadPost *.gpg let &ch=ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    " (If you use tcsh, you may need to alter this line.)
    autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg2 --default-recipient-self -ae 2>/dev/null
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost *.gpg u
augroup END

" }}}

" Backup/swap/undo {{{

set backup
set undofile
set undoreload=10000

set undodir=~/.vim/tmp/undo
set backupdir=~/.vim/tmp/backup
set directory=~/.vim/tmp/swap

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}

" Key bindings {{{

let mapleader=','

" Remove trailing white space http://vim.wikia.com/wiki/Remove_unwanted_spaces
nnoremap <silent><leader>c :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

nnoremap <leader>l :setlocal list!<CR>
nnoremap <leader>n :setlocal number!<CR>
nnoremap <leader>s :setlocal spell!<CR>

nnoremap <silent> <leader>bd :Sbd<CR>
nnoremap <silent> <leader>bdm :Sbdm<CR>

nnoremap <silent> <leader>t :NERDTreeToggle<CR>

" }}}

" Runtime {{{

let g:sh_noisk=1
let python_highlight_all=1
let ruby_space_errors=1

let NERDTreeRespectWildIgnore=1

" }}}

" Printing {{{

set printexpr=PrintFile(v:fname_in)
set printoptions=syntax:n,paper:A4

function PrintFile(fname)
    call system("lp " . a:fname)
    call delete(a:fname)
    return v:shell_error
endfunc

" }}}
