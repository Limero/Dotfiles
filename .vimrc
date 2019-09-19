if executable('fzf')
  if has('nvim')
    nnoremap <C-P> :call fzf#run({"source": "git ls-files --exclude-standard --cached --others \|\| find -L -type f -printf '%P\n'", "sink": "tabedit", "options": "--reverse --preview 'bat --style=numbers --color=always {}'"})<CR><CR>
    autocmd! FileType fzf
    autocmd  FileType fzf set norelativenumber noshowmode noruler
      \| autocmd BufLeave <buffer> set showmode ruler
  else
    nnoremap <C-P> :call fzf#run({"source": "git ls-files --exclude-standard --cached --others \|\| find -L -type f -printf '%P\n'", "sink": "tabedit", "down": "100%", "options": "--reverse --preview 'bat --style=numbers --color=always {} \|\| head -100 {}'"})<CR>
  endif
else
  nnoremap \ :tabfind *
endif

set ruler " show the cursor position all the time

" Turn backup off
set nowritebackup
set noswapfile

" Show possible completions with preview
set completeopt=menuone,preview

" netrw (open with :E)
" https://shapeshed.com/vim-netrw/
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3

set path=$PWD/** " http://vim.wikia.com/wiki/Project_browsing_using_find

" possible to autocorrect with things in current file?
" :help command-completion
command -nargs=? Grep vimgrep /<args>/j **/* | copen 25
nnoremap \| :Grep 

" https://stackoverflow.com/questions/33051496/custom-script-for-git-blame-from-vim
" todo: set filetype dynamically
command! -nargs=* Blame call s:GitBlame()
function! s:GitBlame()
   let cmdline = "git blame -w " . bufname("%")
   let nline = line(".") + 1
   botright new
   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap cursorline
   execute "$read !" . cmdline
   setlocal nomodifiable
   execute "normal " . nline . "gg"
   execute "set filetype=php"
endfunction

" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text#Mapping_for_paste
xnoremap p "_dP

" Define commands for common typos
command WQ wq
command Wq wq
command W w
command Q q
nnoremap ; :

" --- Confirmed needed things below
filetype plugin indent on
set autoindent
set number relativenumber
syntax enable
set belloff=all
set mouse=a
set showcmd
colorscheme ron
set encoding=utf-8
set title
set nohlsearch

" Disable intro message
set shortmess+=I

" Use system clipboard
set clipboard=unnamedplus

" Make tab bar, statusline and vertical split screen divider dark
:hi TabLineFill term=bold cterm=bold ctermbg=0
:hi TabLine cterm=none ctermbg=0
":hi StatusLine ctermbg=White ctermfg=0
":hi StatusLineNC ctermbg=White ctermfg=0
:hi VertSplit ctermbg=0 ctermfg=0

set wildmenu

" Ignore cAsEs in Wild menu
set wildignorecase
" Ignore compiled files
set wildignore=*.o,*~,*.class,*.pyc
" Random filetypes
set wildignore+=*.png,*.jpg,*.svg,*.pdf,*.graphml,*.eot,*.woff,*.log,*.sqlite
" Directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/node_modules/*,*/vendor/*,*/cache/*,*/bin/*,*/.DS_Store

" Close curly brackets
ino {<CR> {<CR>}<ESC>O

" Keep selected text selected when fixing indentation
vnoremap < <gv
vnoremap > >gv

" http://vim.wikia.com/wiki/Moving_lines_up_or_down#Mappings_to_move_lines
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

set list
set listchars=tab:>-,nbsp:%,trail:·

set scrolloff=15 " Show rows above/below cursor

" Remove octal numbers for Ctrl-A and Ctrl-X, it's confusing
set nrformats-=octal

" Ignore case when searching, except when search string has capitalisation
set ignorecase smartcase

" Jump to search results while typing
set incsearch

" Open new splits on opposite side
set splitbelow splitright

" https://www.johnhawthorn.com/2012/09/vi-escape-delays/
" noesckeys will disable cursor/func keys in insert mode,
" so set delay instead
set ttimeoutlen=0

" ctags
" https://stackoverflow.com/a/563992
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" 1 tab == 2 spaces
set smarttab
set expandtab
set shiftwidth=2 tabstop=2

" 1 tab == 4 spaces in specific languages
autocmd Filetype php setlocal shiftwidth=4 tabstop=4

autocmd FileType php set indentkeys-==*/ " Prevent */ in multiline comment to be indented

" Disable continuation of comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Prevent std:: from jumping to beginning of line
autocmd FileType cpp set cinoptions+=L0

autocmd FileType go,c set listchars=tab:\ \ ,nbsp:%,trail:·
autocmd FileType go,c set noexpandtab

" Enable spell checking
" https://www.linux.com/learn/using-spell-checking-vim
set spelllang=en_us
autocmd FileType markdown set spell

autocmd FileType help wincmd T " Open help in new tab

" Commenting blocks of code.
" https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim/1676672#1676672
autocmd FileType c,cpp,java,php,go         let b:comment_leader = '// '
autocmd FileType sh,python,dockerfile,yaml let b:comment_leader = '# '
autocmd FileType conf,fstab                let b:comment_leader = '# '
autocmd FileType vim                       let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" https://coderwall.com/p/faceag/format-json-in-vim
com! FormatJSON %!python -m json.tool

" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
autocmd FocusGained,BufEnter * :checktime
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
