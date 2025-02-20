""
" .vimrc
""

" Pathogen integration
execute pathogen#infect()
let g:ctrlp_working_path_mode = 'r' " Ctrl+P uses working directory ancestor as search path
"let g:ctrlp_regexp = 1

syntax on             " Enable syntax highlighting
set background=dark
colorscheme solarized " Hurr durr what does this line do

set ruler       " Enable line and column counter
set number      " Enable line numbers in the left-hand column
set modelines=0 " Disable modeline support for security reasons

" Remember last position when re-opening a file
if has("autocmd")
  augroup memory
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  augroup END
endif

" Load indentation rules and plugins with file type detection
filetype plugin indent on
set tabstop=10    " Interpret tab characters as 2 columns wide
set shiftwidth=2  " Number of columns to indent text with the reindent operation
set softtabstop=2 " Number of columns the "tab" key should indent
set shiftround    " Shift text to the next multiple of shiftwidth (instead of by shiftwith character count)
set expandtab     " When you hit the "tab" key, insert spaces instead of tabs

" File-specific indentation rules
if has("autocmd")
  augroup indentrules
    autocmd!
    autocmd Filetype php setlocal sts=4 sw=4
  augroup END
endif

set showcmd     " Show (partial) command in status line.
set showmatch   " Highlight matching brackets.
set ignorecase  " Do case insensitive matching
set smartcase   " Do smart case matching
set incsearch   " Enable incremental search
set autowrite   " Automatically save before commands like :next and :make
set hidden      " Hide buffers when they are abandoned
set mouse=a     " Enable mouse usage in visual mode
set backspace=2 " Make backspace work like you would expect it to
set scrolloff=999 " Scroll the file instead of moving the cursor
"set foldmethod=indent " Enable automatic code folding based on block indentation

"augroup OpenFolds
"  autocmd!
"  autocmd BufRead * normal zR
"augroup END

" Airline status bar
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1        " Enable tab bar
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

set laststatus=2 " Always display the status line
set clipboard=unnamed " Use OS X system clipboard with vim cut/copy/paste commands
set timeoutlen=1000 ttimeoutlen=0 " Respond quicker to mode changes
set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace characters

" Key map for buffer navigation
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <Leader>q :bdelete<CR>

" Git gud scrub
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Down> :echoe "Use j"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Right> :echoe "Use l"<CR>

" NERDTree
"autocmd VimEnter * NERDTree   " Open on startup
"autocmd VimEnter * wincmd p   " Focus on the editor window at startup
map <C-n> :NERDTreeToggle<CR> " Quick toggle Ctrl+N
" Close with main window
if has("autocmd")
  augroup nerdtree
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END
endif

" Syntastic
let g:airline#extensions#syntastic#enabled = 1
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_ruby_rubocop_exe = 'rubocop --force-exclusion'
let g:syntastic_javascript_eslint_exe = 'yarn run eslint --fix'

" Indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
"let g:indent_guides_guide_size  = 1
let g:indent_guides_auto_colors = 0
if has("autocmd")
  augroup indentguides
    autocmd!
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=black ctermbg=0
    "autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=black ctermbg=0
  augroup END
endif

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

nnoremap gb :G blame<CR>
nnoremap <Leader>fp :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <Leader>af :Autoformat<CR>
nnoremap <Leader>wq :write\|Bdelete<CR>

if has("autocmd")
  augroup templates
    autocmd!
    autocmd BufNewFile *.sh 0r ~/.vim/templates/shebang.sh
    autocmd BufNewFile *_spec.rb 0r ~/.vim/templates/rspec.rb
    autocmd BufNewFile *_worker.rb 0r ~/.vim/templates/sidekiq_worker.rb
    autocmd BufNewFile *_controller.rb 0r ~/.vim/templates/rails_controller.rb
  augroup END
endif

" Automatically create intermediate directories when saving a file
" https://stackoverflow.com/a/4294176
function s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
