" 外部コマンドで現在のファイルを実行する
autocmd BufNewFile,BufRead,BufEnter *.rb nnoremap <C-e> :!ruby %