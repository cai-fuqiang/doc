call plug#begin('~/.nvim/plugged')
Plug 'Yggdroot/LeaderF' 
Plug 'mileszs/ack.vim'
Plug 'preservim/tagbar'

Plug 'ferrine/md-img-paste.vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
" Plug 'gabrielelana/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'Yggdroot/indentLine'
Plug 'crusoexia/vim-monokai'
Plug 'vim-airline/vim-airline'       
Plug 'vim-airline/vim-airline-themes' "airline 的主题
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'joker1007/vim-markdown-quote-syntax'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'dhananjaylatkar/cscope_maps.nvim' 
Plug 'folke/which-key.nvim' 
Plug 'nvim-telescope/telescope.nvim' 
call plug#end()

autocmd FileType * setlocal textwidth=80 formatoptions+=t
set number
let mapleader = ","
set t_Co=256             " 开启256色支持
syntax enable            " 开启语法高亮功能
syntax on                " 自动语法高亮
set cursorline           " 高亮显示当前行
set autowrite      	 " 设置自动保存
"set expandtab            " 将制表符扩展为空格
set tabstop=8           " 设置编辑时制表符占用空格数
set shiftwidth=8         " 设置格式化时制表符占用空格数
set softtabstop=8        " 设置4个空格为制表符
"set textwidth=40
set nofoldenable
highlight link RnvimrNormal CursorLine

" Yggdroot/indentLine
let g:indent_guides_guide_size            = 1  " 指定对齐线的尺寸
let g:indent_guides_start_level           = 2  " 从第二层开始可视化显示缩进

" vim monokai
colo monokai

" nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<cr>
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHighlightFoldersFullName = 1

" tagbar let g:tagbar_width = 30
let g:tagbar_width = 30
nnoremap <silent> <leader>t :TagbarToggle<cr>
"
"ctags
if filereadable("cscope.out")
   set tags=tags
elseif $CSCOPE_DB != ""
    set tags=$TAGS_DB
endif


"md-img-paste
autocmd FileType markdown nmap <buffer><silent> <C-p> :call mdip#MarkdownClipboardImage()<CR>
let g:mdip_imgdir = 'img'
let g:mdip_imgname = 'image'
" there are some defaults for image directory and image name, you can change them
" coc.nvim

let g:coc_global_extensions = [
	\ 'coc-css',
    \ 'coc-diagnostic',
    \ 'coc-docker',
    \ 'coc-eslint',
    \ 'coc-explorer',
    \ 'coc-flutter-tools',
    \ 'coc-gitignore',
    \ 'coc-html',
    \ 'coc-import-cost',
    \ 'coc-java',
    \ 'coc-jest',
    \ 'coc-json',
    \ 'coc-lists',
    \ 'coc-omnisharp',
    \ 'coc-prettier',
    \ 'coc-prisma',
    \ 'coc-pyright',
    \ 'coc-snippets',
    \ 'coc-sourcekit',
    \ 'coc-stylelint',
    \ 'coc-syntax',
    \ 'coc-tailwindcss',
    \ 'coc-tasks',
    \ 'coc-translator',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ 'coc-vimlsp',
    \ 'coc-yaml',
	\ 'coc-vimlsp',
    \ 'coc-yank']

" vim -markdown
let g:vim_markdown_conceal = 1
set conceallevel=2
set concealcursor="nc"
let g:indentLine_concealcursor = ''
"let g:vim_markdown_folding_disabled = 1

" vim-easymotion
let g:EasyMotion_smartcase = 1 
map <leader>w <Plug>(easymotion-bd-w)
nmap <leader>w <Plug>(easymotion-overwin-w)
nmap <leader>g 60 l

" cscope
lua << EOF
  require("cscope_maps").setup({})
EOF

cmap cs Cscope

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
