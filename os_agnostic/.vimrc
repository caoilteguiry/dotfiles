set number         " show line numbers
set shiftwidth=4   " 4-spaces per indentation
set expandtab      " insert spaces for tabs...
set tabstop=4      " ...specifically 4 spaces
set hlsearch       " highlight search results
set ruler          " list current line number/col number in bottom RHS
set cursorline     " highlight current line

" syntax highlighting just gets in the way when using vimdiff, imho
if v:progname =~ "vimdiff"
    syntax off
else
    syntax on
endif

" Clear highlighting with C-l
nnoremap <silent> <C-l> :nohls<CR><C-l>

" Include a host-specific file (if it exists!)
try
    exec ":source ~/.vimrc." . hostname()    
catch
endtry
