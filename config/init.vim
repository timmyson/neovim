"------------------------------------------------------------------------------"
" Neovim Configuration                                                         "
"------------------------------------------------------------------------------"

" Pathogen
" https://github.com/tpope/vim-pathogen
"
" A vim plugin manager that makes it super easy to install plugins and runtime
" files in their own private directories.
call pathogen#infect()                            " Initialize Pathogen

" Theme
" https://github.com/freeo/vim-kalisi
"
" A theme designed with neovim in mind.
set background=dark                               " Use dark version of theme.
colorscheme tim.vim                                " Use kalisi color scheme.

" Tweeks
"
" Small changes that make vim a little easier to use.
syntax on                                         " Enable syntax highlighting.
set wildchar=<Tab> wildmenu wildmode=longest,list " Bash-like completion.
set backspace=indent,eol,start                    " Backspace anything!
set expandtab                                     " Use spaces by default.
set hidden                                        " Switch buffers w/o saving.
set completeopt-=preview                          " Disable completion preview.
set splitright                                    " Open new split to the right.
set nohlsearch                                    " Disable highlight search.
set relativenumber                                " Show relative line numbers.
set inccommand=nosplit                            " Preview substitutions.
set copyindent                                    " Copy previous indent on <CR>.
set number                                        " On current line, show
                                                  " absolute line number.

" DetectIndent
" https://github.com/roryokane/detectindent
"
" Uses fancy algorithms to try and figure out what style of indentation the
" current buffer uses.
let g:detectindent_preferred_indent = 4           " 4 spaces by default.
autocmd BufReadPost * :DetectIndent               " After reading buffer, detect
                                                  " indentation.

" Filetype
"
" Detects the type of the current file based of the extension and contents,
" and perform actions.
filetype on                                       " Enable the plugin.
filetype indent on                                " Better indentation.
filetype plugin on                                " Load filetype specific
                                                  " plugins.

" Antlr Syntax
au BufRead,BufNewFile *.g4 set filetype=antlr4    " Set filetype for *.g4 files

" Highlight Trailing Whitespace
"
" Track which buffers have been created, and set the highlighting only once.
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1
highlight WhitespaceEOL ctermbg=red ctermfg=white guibg=#592929
autocmd WinEnter *
  \ if !exists('w:created') | call matchadd('WhitespaceEOL', '\s\+$') | endif
call matchadd('WhitespaceEOL', '\s\+$')

" Highlight Past Column 80
"
" Change the background color past column 80 to indicate you've typed too
" much.
highlight ColorColumn ctermbg=239 guibg=#39393b
execute "set colorcolumn=" . join(range(81,335), ',')

" Embedded Terminal
"
" Neovim supports an embedded terminal with :terminal, these tweaks make it a
" little easier to work with.
tnoremap <Esc> <C-\><C-n>                         " Exit terminal with <Esc>

" Add tsplit command to open a new terminal in a split
if !exists(":tsplit")
  command -nargs=? Tsplit vsplit | terminal <args>
  ca tsplit Tsplit
endif

"" Pending https://github.com/neovim/neovim/issues/5310
"" Relative line numbers in terminal (set nonumber to keep margin fixed size)
"autocmd TermOpen * set nonumber relativenumber

" Hardtime
" https://github.com/takac/vim-hardtime
"
" Break bad vim patterns, forces you to use better movement keys.
autocmd VimEnter,BufNewFile,BufReadPost * silent! HardTimeOn
nnoremap <leader>h <Esc>:HardTimeToggle<CR>       " Toggle hardtime with <leader>h.
let g:hardtime_ignore_quickfix = 1                " Disable in quickfix windows.
let g:hardtime_allow_different_key = 1            " Allow different keys in succession.

let g:list_of_normal_keys = ["h", "j", "k", "l",
  \                          "-", "+", "<UP>",
  \                          "<DOWN>", "<LEFT>",
  \                          "<RIGHT>", "<CR>"]   " Which keys to lock.

" Airline
" https://github.com/bling/vim-airline
" https://github.com/powerline/fonts
"
" Sweet looking status line. Requires powerline fonts to be enabled in your
" terminal.
let g:airline_theme='kalisi'                      " Use the kalisi theme!
let g:airline_powerline_fonts=1                   " Enable powerline fonts.
set noshowmode                                    " Don't show mode in command line.
let g:airline#extensions#tabline#enabled=1        " Show the tabline.
let g:airline#extensions#tabline#buffer_nr_show=1 " Show buffer numbers.
let g:airline#extensions#tabline#show_tabs=0      " Don't show tabs in tabline.

" YouCompleteMe
" https://github.com/Valloric/YouCompleteMe
"
" Code completion, everywhere.
nnoremap <leader>jd <Esc>:YcmCompleter GoTo<CR>   " Jump to definition.
let g:ycm_global_ycm_extra_conf = '~/.local/share/nvim/site/ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<S-TAB>']

" Eclim
"
let g:EclimCompletionMethod = 'omnifunc'          " Required for YCM to work.

" Signify
" https://github.com/mhinz/vim-signify
"
" Indicates added, modified and removed lines based on data of an underlying
" version control system.
let g:signify_vcs_list = [ 'git' ]

" ZoomWinTab
" https://github.com/troydm/zoomwintab.vim
"
" Makes <C-w>o toggle zooming in and out
let g:zoomwintab_hidetabbar=0                     " Don't hide tabbar when zoom.

" Neomake
" https://github.com/neomake/neomake
"
" Asynchronously run programs.
highlight NeomakeError ctermfg=196
call neomake#configure#automake('nw', 750)        " Auto-make after 750ms

" Custom Code Folding
"
" Vim's default fold text isn't super useful, so we replace it with something
" a little better.
set foldlevelstart=99                             " Expand all folds by default.
set foldtext=CustomFoldText()                     " Enable our sweet fold text.
set foldmethod=syntax                             " Fold based on syntax.
function! CustomFoldText()
  " Get the first non-blank line
  let fs = v:foldstart
  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  " Get the last non-blank line
  let fe = v:foldend
  while getline(fe) =~ '^\s*$' | let fe = prevnonblank(fe - 1)
  endwhile

  if fe < v:foldstart
    let eline = getline(v:foldend)
  else
    let eline = substitute(getline(fe), '\t', repeat(' ', &tabstop), 'g')
  endif

  if fs != fe
    let line = line . " ... " . substitute(eline, '^\s*', '', '')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 4 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let lineCount = line("$")
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line))
  return line . expansionString . foldSizeStr
endfunction
" vim: set et ts=2 sw=2:
