{ config, pkgs, ... }:
{
  tudor.home = {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-sensible

        fzf-vim
        polyglot
        ale
        gitgutter
        tabular
        colorizer
        easymotion
        vim-abolish
        vim-move
        editorconfig-vim
      ];

      extraConfig = ''
      filetype off

      set encoding=utf-8
      scriptencoding utf-8

      set rtp+=/usr/share/vim/vimfiles

      function! VarOrDefault(param, default)
          if len(a:param) == 0
              return a:default
          else
              return a:param
          endif
      endfunction

      let cache_dir = VarOrDefault($XDG_CACHE_HOME, '~/.cache')

      filetype plugin indent on

      " Essential settings {{{

      " Syntax and tabs
      syntax enable
      set background=light

      set number

      " Make things snappy
      set updatetime=250

      " Fold markers
      set fdm=marker

      " Respect case in searches only if search query contains upper-case chars
      set ignorecase
      set smartcase
      set infercase

      " Other search tricks
      set hlsearch
      set incsearch
      set inccommand=split

      " Make it natural
      set splitright
      set splitbelow

      " Make buffers more emacs-y
      set hidden
      set autochdir

      " Kill lag
      set lazyredraw

      " Use system's clipboard (X's CLIPBOARD)
      set clipboard^=unnamedplus

      " Nope
      set noswapfile
      " Set backup/undo dirs
      let &backupdir = cache_dir . '/nvim/tmp/backups/'
      let &undodir = cache_dir . '/nvim/tmp/undo/'

      " Make the folders automatically if they don't already exist.
      if !isdirectory(expand(&backupdir))
          call mkdir(expand(&backupdir), "p")
      endif

      if !isdirectory(expand(&undodir))
          call mkdir(expand(&undodir), "p")
      endif

      " Make undo work after the file is closed
      set undofile
      set undolevels=500
      set undoreload=500

      " }}}

      " Keybindings {{{

      " Leader-d to hide find results
      nnoremap <silent> <Leader>d :noh<CR>
      " Just in case
      cabbr W w
      cabbr Q q
      cabbr Wq wq

      map <Space> <Leader>
      nmap <Leader>ws :split<CR>
      nmap <Leader>wv :vsplit<CR>

      map <Leader>wh <C-w>h
      map <Leader>wj <C-w>j
      map <Leader>wk <C-w>k
      map <Leader>wl <C-w>l
      map <Leader>w= <C-w>=
      map <Leader><Space> <C-w><C-w>
      nmap <Leader>r :WinResizerStartResize<CR>
      nmap <Leader>w :w<CR>

      nnoremap <silent> B :Buffers<CR>

      " }}}

      " Whitespace stripping {{{

      highlight ExtraWhitespace ctermbg=red
      autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
      match ExtraWhitespace /\s\+$/
      autocmd BufWritePre * %s/\s\+$//e

      " }}}

      " Romanian Digraphs {{{
      " Vim comes default with turkish ş and ţ

      dig S, 536 " Ș
      dig s, 537 " ș

      dig T, 538 " Ț
      dig t, 539 " ț

      " }}}
      '';
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
