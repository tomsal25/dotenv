function! GetFileFormat()
    let ff = &fileformat
    if ff == "unix"
        return "LF"
    elseif ff == "dos"
        return "CRLF"
    else
        return ff
    endif
endfunction

" no swap
set noswapfile

" fix backspace
set backspace=indent,eol,start

" status line
set statusline=%r " show if read only
set statusline+=%t " file name
set statusline+=%m " show if modded
set statusline+=%= " separator
set statusline+=%{&fileencoding} " file encodeing
set statusline+=\ %{GetFileFormat()} " file format
set laststatus=2

syntax on
