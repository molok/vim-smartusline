SmartusLine
-----------

SmartusLine is Vim plugin that changes the color of the statusline of the
focused window according with the current mode (normal/insert/replace)

it looks like this:

![SmartusLineGif](https://github.com/molok/vim-smartusline/raw/master/img/smartusline.gif)

by default it highlights the filename on your statusline only, you can change
that:

    let g:smartusline_string_to_highlight = '(%n) %f '

this is what you see in the picture.

You can also change the default colors of the highlight, the name are
self-explanatory, the defaults are:

    let g:smartusline_hi_replace = 'guibg=#e454ba guifg=black ctermbg=magenta ctermfg=black'
    let g:smartusline_hi_insert = 'guibg=orange guifg=black ctermbg=58 ctermfg=black'
    let g:smartusline_hi_virtual_replace = 'guibg=#e454ba guifg=black ctermbg=magenta ctermfg=black'
    let g:smartusline_hi_normal = 'guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black'

note: you probably want to set the statusline to never hide, like this:

    set laststatus=2

other requirements are:

    set nocompatible
    syntax on

also the statusline option can't be empty, if you want to use the
default statusline you should set it explicitly in your vimrc, it should be
something like this:

	  set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P


For a more complete documentation, read the help file (:help smartusline)

Enjoy!

    
