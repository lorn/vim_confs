" ----------------------------------------------------------------------
"   ~/.vimrc && ~/.gvimrc
"
"       Otavio Fernandes <otaviof@gmail.com>
" ----------------------------------------------------------------------

set ai                          " always set autoindenting on.
set autowrite                   " deixa gravar arquivos simultaneamente
set autowriteall                " deixa gravar muitos arquivos ao mesmo
                                " tempo, subentende-se que o autowrite
                                " esta ligado
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set browsedir=current           " diretorio onde primeiro vamos procurar
                                " arquivos para abrir
set cinoptions=(0               " set the cinoptions. Use the default
                                " for everything except the ( option.
" set gdefault                  " set 'g' substitute flag on.
set history=50                  " keep 50 lines of command line history
set incsearch                   " do incremental searching
set joinspaces                  " insert two spaces after a period with every joining of lines.
set nobackup                    " do not keep a backup file, use versions instead
" set backupdir=/var/tmp/vim_bkps " diretorio de backups do vim
set nocompatible                " changes other options as a side effect.
set ruler                       " show the cursor position all the time
set shiftwidth=4                " numero de espacos utilizado para
                                " indentacao
set expandtab                   " sempre vamos usar espacos, no lugar
                                " dos tabs
set showcmd                     " display incomplete commands
set showmatch                   " showmatch: Show the matching bracket for the last ')'?
set smartindent                 " adiciona itens de indentacao nos
                                " fontes editados pelo Vim
set smarttab                    " identa��o para os tabs
set tabstop=4                   " melhora a identa��o, principalmente de ANSI C
set softtabstop=4               
set tildeop                     " allow tilde (~) to act as an operator -- ~w, etc.
set ts=4                        " setando o tamanho do tab
set wildignore=*.bak,*.o,*.e,*~
set wildmenu                    " mostra os menus em cima da linha de comando
set wrap                        " quebra a linha automaticamente
set textwidth=72                " quantos caracteres vamos ter por linha
set nomodeline                  " op��o de seguran�a
set vb t_vb=''                  " no bell sound
set confirm                     " to get a dialog when a command fails
set complete+=k                 " scan the files given with the 'dictionary' option
set autoread                    " read open files again when changed outside Vim
set showmode                    " show mode (Visual, Insert, Select, etc)
set selectmode=mouse	        " select mode will be started by shift keys

" sempre havera plugins ligados
filetype on
filetype plugin on
filetype indent on

" caso o terminal suporte, vamos habilitar syntax hilight
if &t_Co > 1
    syntax enable
endif

" caso a interface grafica estaja rodando, vamos setar:
if has("gui_running") 

    colorscheme no_quarter      " esquema de cores, Otavio Fernandes ;-)
    " set noantialias             " para leitura e coficacao eh melhor
                                " remover o antialias
    set background=dark         " tipo de background

    " set fileencodings=ucs-bom,utf-8,default,latin1
    " set guifont=Monaco:h10
    " set guifont=-*-proggytinysz-*-*-*-*-10-*-*-*-*-*-iso8859-1
    " set guifont=ProggyTinyTTSZ\ 12
    " set guifont=Terminus\ 8
    " set guifont=Monaco\ 8

    set guifont=Monaco:h12
    set helplang=en             " lingua default
    set mouse=a                 " deixaremos o mouse interagir com o Vim
    set mousehide               " hide mouse while typing
    set termencoding=utf-8    	" codificacao padrao do Mac OS X e
                                " qualquer outro SO hoje
    set transparency=7          " o MacVim tem suporte a transparencia
    set linespace=-5            " economizando um pouco de espaco entre
                                " as linhas, para codificar, ente -1 e -3
    set lines=40 columns=96     " standard window size we were used to
    set cursorline              " destaca a linha atual com as cores que
                                " sao setadas no tema (colorscheme)
    set invnumber               " exibindo o numero nas linhas

    set guitablabel=(%N%M)\ %f

endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " carregando plugin do doxygen
    au! Syntax {cpp,c,idl}
    au Syntax {cpp,c,idl} runtime syntax/doxygen.vim

    au Syntax {xml,xhtml,html,htm,erb,tt2.html} runtime ftplugin/xml.vim

    " opcoes para ruby
    augroup ruby
        if !exists("autocommands_ruby_loaded")
            let autocommands_ruby_loaded = 1
            au BufReadPre *.rb set shiftwidth=2 ts=2 sw=2 sts=2 nu | let IndentStyle = "ruby"
            au BufNewFile *.rb 0r ~/.vim/skeleton.rb | let IndentStyle = "ruby"
        endif
    augroup END

    " carregando o plugin de xml/html
    autocmd FileType {xml,xhtml,html,htm,erb,tt2.html} runtime ftplugin/xml.vim

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
    augroup END

endif

"
" Removendo os maltidos ^M's do DOS
"
"
fun RmCR()
    let oldLine=line('.')
    exe ":%s/\r//g"
    exe ':' . oldLine
endfun
map ,cr :call RmCR()<CR>


"
" Funcao de completar palavras
"

function! Mosh_Tab_Or_Complete()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-N>"
    else
        return "\<Tab>"
endfunction

" alt-/ para completar as palavras...
" inoremap <M-/> <C-R>=Mosh_Tab_Or_Complete()<CR>
" inoremap <m-/> <C-R>=Mosh_Tab_Or_Complete()<CR>
inoremap <D-/> <C-R>=Mosh_Tab_Or_Complete()<CR>

"
" Fechando parenteses automaticamente e criando blocos
"

inoremap ( ()<ESC>i
vnoremap _( <ESC>`>a)<ESC>`<i(<ESC>))
imap _* <Esc>bi*<Esc>ea*<Space>
inoremap { {}<ESC>i
inoremap [ []<ESC>i
inoremap <F9> {<CR><BS>}<ESC>ko

"
" mostrando o numero a cada linha
"

map <F7> :set invnumber<CR>

"
" Spell checking for pt_BR and en_US
"

map ,g :runtime spell/<CR>:set spl=pt,en spell<CR>

"
" Tidy-up coding style
"

map ,t :call Tidy()<Cr>

function! Tidy()
    let current_line = line('.')
    if &filetype == "perl"
        let tidy = 'perltidy -pbp -ce'
    elseif &filetype == "php"
        let tidy = 'php_beautifier -s4 --filters "NewLines(after=T_DOC_COMMENT,before=if:switch)"'
    elseif &filetype == "c"
        let tidy = 'indent -orig -i4 -l78 -fca -lc78 -ts4 -br -cdw -nbad -di8 -bap'
    endif
    execute ":0,$!" . tidy
    execute ":" . current_line
endfunction

"
" Perl Completion Behavior
"

fun! PerlCompletionBehavior()
    let behavs = {'perl':[]}
    call add(behavs.perl, {
        \ 'command' : "\<C-x>\<C-o>",
        \ 'pattern' : printf('\w->\k\{%d,}$',1),
        \ 'repeat' : 0,
        \ })
    return behavs
endf

let g:acp_behavior = {}
cal extend(g:acp_behavior, PerlCompletionBehavior(), 'keep')


"
" Nos leva ate a funcao a declaracao de uma funcao (Perl)
" 

function! GotoSub(subname)
    let files  = []

    " find paths to modules with that sub
    let paths = split(system("ack --perl -l 'sub\\s+".a:subname."' lib t/lib"), "\n")

    if empty(paths)
        echomsg("Subroutine '".a:subname."' not found")
    else
        let file = PickFromList('file', paths)
        execute "edit +1 " . file

        " jump to where that sub is defined
        execute "/sub\\s\\+"  . a:subname . "\\>"
    endif
endfunction

function! PickFromList( name, list, ... )
    let forcelist = a:0 && a:1 ? 1 : 0

    if 1 == len(a:list) && !forcelist
        let choice = 0
    else
        let lines = [ 'Choose a '. a:name . ':' ]
            \ + map(range(1, len(a:list)), 'v:val .": ". a:list[v:val - 1]')
        let choice  = inputlist(lines)
        if choice > 0 && choice <= len(a:list)
            let choice = choice - 1
        else
            let choice = choice - 1
        endif
    end

    return a:list[choice]
endfunction

" se a palavra em que estivermos em cima eh uma funcao, vamos ate ela...
noremap  ,gs  :call GotoSub(expand('<cword>'))<cr>

" 
" Caps-Lock
"

nmap :W :w
nmap :X :x
nmap :Q :q

" 
" UTF8 conversion
"

nmap ,utf8 !recode -q ISO-8859-1..utf-8


"
" Shortcuts for Tabs (Command)
"

map <c-t> :tabnew<cr>
map <c-h> :tabprevious<cr>
map <c-l> :tabnext<cr>

map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
map <D-0> 10g

"
" Perl
"

let perl_include_POD                = 1
let perl_want_scope_in_variables    = 1
let perl_extended_vars              = 1
let perl_no_sync_on_sub             = 1
let perl_no_sync_on_global_var      = 1
let perl_sync_dist                  = 100
let perl_fold                       = 1
let perl_nofold_packages            = 1
let perl_nofold_subs                = 1

let g:def_perl_comp_bfunction       = 1
let g:def_perl_comp_packagen        = 1

let g:Perl_AuthorName               = 'Otavio Fernandes'     
let g:Perl_AuthorRef                = 'OF'                         
let g:Perl_Company                  = 'Locaweb'    
let g:Perl_Email                    = 'otavio.fernandes@locaweb.com.br'   

"
" Tag List Options
"

let Tlist_WinWidth                  = 35
let Tlist_Show_One_File             = 0
let Tlist_Compact_Format            = 0
let Tlist_Auto_Highlight_Tag        = 1
let Tlist_Process_File_Always       = 1
let tlist_perl_settings             = 'perl;c:constants;f:formats;l:labels;p:packages;s:subroutines;d:subroutines;o:POD'
let Tlist_Ctags_Cmd                 = '/opt/local/bin/ctags' " OSX

" maps para chamar o tag list com F6 e F5 (refresh)
nnoremap <silent>  <F6> :Tlist<CR>
nnoremap <silent>  <F5> :TlistUpdate<CR>
nnoremap <silent> <tab> :bn<CR

" habilitando o plugin de xml
let xml_use_xhtml = 1
let b:html_mode = 1

"
" NERDTree
"

map ,n <ESC>:NERDTree<CR>
nnoremap <silent> ,f :call FindInNERDTree()<CR> 


"
" Omni Completion colors
"

hi Pmenu        ctermfg=black       ctermbg=grey    cterm=NONE
hi PmenuSel     ctermfg=darkyellow  ctermbg=black   cterm=inverse

"
" Helptags para o latexSuite
"

helptags ~/.vim/doc

"
" Fuzzy Finder
"

nnoremap <silent> <C-f><C-t> :FuzzyFinderTag!<CR>
nnoremap <silent> <C-]>      :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>

" let g:FuzzyFinderOptions.Base.abbrev_map = {
"           \   "^WORK" : [
"           \     "~/Desktop/",
"           \     "~/Desktop/Workspace/",
"           \     "~/.vim/plugin/",
"           \   ],
"           \ } 

"
" Call gvim file browser
"

noremap  <silent> <s-F8>       :silent browse confirm e<CR>
inoremap  <silent> <s-F8>  <Esc>:silent browse confirm e<CR>
          
" EOF
