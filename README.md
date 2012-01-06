SmartusLine
-----------

SmartusLine is Vim plugin that changes the color of the statusbar of the focused
window according with the current mode (normal/insert/replace)

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


