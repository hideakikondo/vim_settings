" 外部コマンドで現在のファイルを実行する
autocmd BufNewFile,BufRead,BufEnter *.js nnoremap <C-e> :!node %