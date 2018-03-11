""""""""""""""""""""""""""""""""""
" Plugins 
""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugged')

    Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-sensible' | Plug 'tpope/vim-sleuth' | Plug 'tpope/vim-surround' | Plug 'tpope/vim-commentary' | Plug 'tpope/vim-vinegar'

    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"

    Plug 'junegunn/vim-easy-align' | Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    Plug 'mileszs/ack.vim'
    let g:ackprg = 'ag --vimgrep --smart-case'                                                   
    cnoreabbrev ag Ack                                                                           
    cnoreabbrev aG Ack                                                                           
    cnoreabbrev Ag Ack                                                                           
    cnoreabbrev AG Ack  

    Plug 'neomake/neomake'

    Plug 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1

    Plug 'lervag/vimtex'
    " let g:vimtex_view_method = 'zathura'

    " Setup incomplete -- may revist if need arises. 
    " Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }

    Plug 'danilo-augusto/vim-afterglow'

    call plug#end()

" neomake setup -- needs to go below plug#nd()
call neomake#configure#automake('w')

""""""""""""""""""""""""""""""""""
" Searching
""""""""""""""""""""""""""""""""""

" When searching try to be smart about cases 
set smartcase

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" For regular expressions turn magic on
set magic


""""""""""""""""""""""""""""""""""
" Aesthetics
""""""""""""""""""""""""""""""""""

" Colorscheme
set background=dark
colorscheme afterglow

" Turn on line numbers
set number

" Set 5 lines to the cursor - when moving vertically using j/k
set so=5

" Add a bit extra margin to the left
set foldcolumn=1


""""""""""""""""""""""""""""""""""
" Menus and the command line
""""""""""""""""""""""""""""""""""

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U> 
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Ignore certain files for wildmenu
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Height of the command bar
set cmdheight=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


""""""""""""""""""""""""""""""""""
" Writing
""""""""""""""""""""""""""""""""""

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Toggle spell checking
nnoremap <C-S> :setlocal spell!<cr>


""""""""""""""""""""""""""""""""""
" Buffers
""""""""""""""""""""""""""""""""""

" Quick tabedit with CWD as base
nnoremap <C-Q> :tabedit <c-r>=expand("%:p:h")<cr>/

" Reload settings on writing this file.
au! BufWritePost init.vim source $MYVIMRC

" Turn persistent undo on -- means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.config/nvim/undodir
    set undofile
catch
endtry

" :W sudo saves the file -- useful for handling the permission-denied error
if ! exists('sudo_tee_write_set')
    let g:sudo_tee_write_set = 1
    command W w !sudo tee % > /dev/null
endif

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" Use Unix as the standard file type
set ffs=unix,mac,dos

" Set to auto read when a file is changed from the outside
set autoread

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Use latex as default for .tex files
let g:tex_flavor = "latex"


""""""""""""""""""""""""""""""""""
" Helper functions
""""""""""""""""""""""""""""""""""

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

function! CmdLine(str)
    exe "menu foo.bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
