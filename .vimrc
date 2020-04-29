Skip to content
 
Search…
All gists
Back to GitHub
@hideakikondo 
@kickbase kickbase/.vimrc
Last active 3 years ago • Report abuse
0
0
 Code Revisions 2
<script src="https://gist.github.com/kickbase/33ef09a15e86603ad8c59b855f326ce5.js"></script>
  
[Vim] my .vimrc file
 .vimrc
"------- Preferences --------"
set ttyfast
set t_Co=256
set hidden
set autoread
set history=2000
set noswapfile
set backspace=start,eol,indent
set ambiwidth=double
set shortmess+=I
set nrformats=
set backup
set backupdir=$HOME/vimbackup

set smartindent
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
set showmatch
set matchtime=1
set formatoptions-=c
set smarttab
set clipboard=unnamed,autoselect

"ハイフンを単語に含める
set isk+=-

"スペルチェック時に日本語を除外する
set spelllang=en,cjk

" インサートモードから抜けるときにペーストモードを解除する
autocmd InsertLeave * set nopaste

"syntax markdown
au BufRead,BufNewFile *.md set filetype=markdown

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932,utf-16,utf-16le
"set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac

"------- Look&Feel -----"
set ruler
set number
syntax on
filetype on
filetype plugin on
filetype indent on
set title
set showcmd
set cmdheight=2

set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:<
set display=lastline
set pumheight=10

"colorscheme distinguished
"colorscheme railscasts
"colorscheme grb256
"colorscheme darcula
"colorscheme molokai
colorscheme badwolf
au BufNewFile,BufRead *.ejs set filetype=html


"------- Cursor -----"
"挿入モードでカーソル形状を変更する
let &t_SI.="\e[6 q"
let &t_EI.="\e[2 q"
"カーソル形状がすぐに元に戻らないのでタイムアウト時間を調整
set ttimeoutlen=10
"挿入モードを抜けた時にカーソルが見えなくなる現象対策(なぜかこれで治る)
inoremap <ESC> <ESC>
set mouse=a

"------- StatusLine -----"
"http://blog.ruedap.com/2011/07/12/vim-statusline-git-branch-name
"プラグイン必要だったので今は設定しない。替わりに下記を設定
"http://qiita.com/sizucca/items/40f291463a40feb4cd02
"自動文字数カウント
augroup WordCount
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
    if a:0 == 0
        return s:WordCountStr
    endif
    let cidx = 3
    silent! let cidx = s:WordCountDict[a:1]
    let s:WordCountStr = ''
    let s:saved_status = v:statusmsg
    exec "silent normal! g\<c-g>"
    if v:statusmsg !~ '^--'
        let str = ''
        silent! let str = split(v:statusmsg, ';')[cidx]
        let cur = str2nr(matchstr(str, '\d\+'))
        let end = str2nr(matchstr(str, '\d\+\s*$'))
        if a:1 == 'char'
            " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
            let cr = &ff == 'dos' ? 2 : 1
            let cur -= cr * (line('.') - 1)
            let end -= cr * line('$')
        endif
        let s:WordCountStr = printf('%d/%d', cur, end)
    endif
    let v:statusmsg = s:saved_status
    return s:WordCountStr
endfunction

"ステータスラインにコマンドを表示
set showcmd
"ステータスラインを常に表示
set laststatus=2
"ファイルナンバー表示
set statusline=[%n]
"ホスト名表示
set statusline+=%{matchstr(hostname(),'\\w\\+')}@
"ファイル名表示
set statusline+=%<%F
"変更のチェック表示
set statusline+=%m
"読み込み専用かどうか表示
set statusline+=%r
"ヘルプページなら[HELP]と表示
set statusline+=%h
"プレビューウインドウなら[Prevew]と表示
set statusline+=%w
"ファイルフォーマット表示
set statusline+=[%{&fileformat}]
"文字コード表示
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
"ファイルタイプ表示
set statusline+=%y

"------- netrw -----"
"http://blog.tojiru.net/article/234400966.html  
" netrwは常にtree view
let g:netrw_liststyle = 3
" CVSと.で始まるファイルは表示しない
let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'
" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1


"------- Search --------"
set incsearch
set ignorecase
set smartcase
set wrapscan
set hlsearch
":grepコマンドをackに変更
set grepprg=ack\ --nogroup\ --column\ $*
set grepformat=%f:%l:%c:%m

"------- & command --------"
nnoremap & :&&<CR>
xnoremap & :&&<CR>


"現在の選択範囲を検索する
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

"quickfixリストに含まれるファイル名を引数リストに設定する
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction


"------- plugins --------"
runtime macros/matchit.vim

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" gaでテキスト揃え
Plug 'junegunn/vim-easy-align'

" Pythonの自動補完
Plug 'davidhalter/jedi-vim'

" KillRing的なやつ
Plug 'LeafCage/yankround.vim'

" vで選択範囲を拡大、C-vで選択範囲を戻す
Plug 'terryma/vim-expand-region'

" C--2回押しで選択範囲をまとめてコメントアウト
Plug 'tomtom/tcomment_vim'

" gxでカーソル下のURLをブラウザで開く(URLでなければ検索結果を開く)
Plug 'tyru/open-browser.vim'

" テキストを囲うものを様々に編集
Plug 'tpope/vim-surround'

" 閉じカッコの自動挿入
Plug 'cohama/lexima.vim'

" インデントの可視化
Plug 'Yggdroot/indentLine'

" 候補絞り込み型インターフェース
Plug 'kien/ctrlp.vim'
" CtrlPの拡張プラグイン. 関数検索
Plug 'tacahiroy/ctrlp-funky'

" CtrlPの拡張プラグイン. コマンド履歴検索
Plug 'suy/vim-ctrlp-commandline'

" CtrlPの拡張プラグイン 3つの機能が同梱
Plug 'sgur/ctrlp-extensions.vim'

" vimからagを利用する
Plug 'rking/ag.vim'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Initialize plugin system
call plug#end()


"------- plugin settings --------"
" ctrlp
" let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100'
" .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_show_hidden = 1
" ファイル検索のみ使用
let g:ctrlp_types = ['fil'] 
" CtrlPの拡張指定
let g:ctrlp_extensions = ['funky', 'commandline', 'yankring'] 
"C-pでCtrlPMenuが起動するように
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMenu'
" CtrlPCommandLineの有効化
command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())
" CtrlPFunkyの有効化
let g:ctrlp_funky_matchtype = 'path' 
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files           = 100000
let g:ctrlp_mruf_max            = 500
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.?(git|hg|svn|cache|emacs\.d|node_modules)$',
  \ 'file': '\v\.(exe|so|dll|dmg|tar|gz|c4d|DS_Store|zip|mtl|lxo|psd|ai|eps|pdf|aep|jpe?g|png|gif|tif|swf|svg|obj|fbx|mov|mp[3-4])$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" jedi-vim
" docstringポップアップを無効化
autocmd FileType python setlocal completeopt-=preview

" indentLine
" 任意のファイルタイプで無効化する
let g:indentLine_fileTypeExclude = ['help', 'markdown']

"------- Keymap -----"
inoremap <C-c> <ESC>
noremap <C-c><C-c> :nohlsearch<Cr><Esc>
set whichwrap=b,s,h,l,<,>,[,],~
let mapleader = "\<Space>"
nnoremap <Leader>s :w<CR>
nnoremap <Leader>/ /\v
nnoremap <Leader>?  ?\v
nnoremap Y y$
nnoremap + <C-a>
nnoremap - <C-x>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
set pastetoggle=<f5>
map <f6> :!open -a textedit %<CR>
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" 選択範囲を広げる
vmap v <Plug>(expand_region_expand)
" 選択範囲を戻す
vmap <C-v> <Plug>(expand_region_shrink)
" カーソル下のURLをブラウザで開く
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
@hideakikondo
 
Leave a comment

Attach files by dragging & dropping, selecting or pasting them.
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
