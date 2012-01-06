" smartusline.vim
" ---------------------------------------------------------------
" Version:  0.2
" Authors: Alessio 'molok' Bolognino <alessio.bolognino+vim@gmail.com>
" Last Modified: 2012-01-06
" License:  GPL (Gnu Public License)
" ------------------------------------------------------------------------------
" Known reproducible bug:
" :e foobar
" :help help
" :NERDTreeToggle
" :NERDTreeToggle
" triggers WinEnter in foobar instead of change, could be a NERDTreeBug

if exists('g:loaded_smartusline') || &cp
    finish
endif

if &stl == ""
    echoerr "SmartusLine: statusline can't be empty"
    finish
endif

let g:loaded_smartusline = 0.2
let s:keepcpo         = &cpo
set cpo&vim

if !exists('g:smartusline_hi_replace')
    let g:smartusline_hi_replace = 'guibg=#e454ba guifg=black ctermbg=magenta ctermfg=black'
endif

if !exists('g:smartusline_hi_insert')
    let g:smartusline_hi_insert = 'guibg=orange guifg=black ctermbg=58 ctermfg=black'
endif

if !exists('g:smartusline_hi_virtual_replace')
    let g:smartusline_hi_virtual_replace = 'guibg=#e454ba guifg=black ctermbg=magenta ctermfg=black'
endif

if !exists('g:smartusline_hi_normal')
    let g:smartusline_hi_normal = 'guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black'
endif

execute 'hi StatColor ' . g:smartusline_hi_normal

"let g:smartusline_string_to_highlight = '(%n) %f '
if !exists('g:smartusline_string_to_highlight')
    let g:smartusline_string_to_highlight = '%f'
endif

let s:open_hi = '%#StatColor#'
let s:close_hi = '%*'

function! SmartusLineWin(mode)

    let curr_stl = &stl
    let new_stl = ""

    let string_to_match = substitute(g:smartusline_string_to_highlight,'\\','\\\\','g')
    let start_idx = match(curr_stl, '\V'. string_to_match)
    let end_idx = start_idx + len(g:smartusline_string_to_highlight)

    if start_idx >= 0
        if a:mode == 'Enter'
            if match(curr_stl, s:open_hi) < 0
                    if start_idx > 0
                        let new_stl .= curr_stl[0 : start_idx -1]
                    endif
                    let new_stl .= s:open_hi 
                    let new_stl .= curr_stl[start_idx : end_idx -1] . s:close_hi
                    let new_stl .= curr_stl[end_idx : ]
                endif
        elseif a:mode == 'Leave'
            if match(curr_stl, s:open_hi) >= 0
                    let new_stl .= curr_stl[0 : end_idx -1] 
                    let new_stl .= curr_stl[end_idx +len(s:close_hi) :]
                    let new_stl = substitute(new_stl, s:open_hi, '', 'g')
            endif
        endif
    endif

    if new_stl != ""
        execute "setlocal statusline=" . substitute(new_stl, ' ', '\\ ', 'g')
    endif

endfunction

function! SmartusLineInsert(mode)
    if a:mode == 'Enter'
        if v:insertmode == 'i'
            execute 'hi StatColor ' . g:smartusline_hi_insert
        elseif v:insertmode == 'r'
            execute 'hi StatColor ' . g:smartusline_hi_replace
        elseif v:insertmode == 'v'
            execute 'hi StatColor ' . g:smartusline_hi_virtual_replace
        endif
    elseif a:mode == 'Leave'
        execute 'hi StatColor ' g:smartusline_hi_normal
    endif
endfunction

au WinLeave * call SmartusLineWin('Leave')
au WinEnter,BufEnter,VimEnter * call SmartusLineWin('Enter')

au InsertLeave * call SmartusLineInsert('Leave')
au InsertEnter * call SmartusLineInsert('Enter')

" this shouldn't be needed, but it is
au GUIEnter * execute 'hi StatColor ' g:smartusline_hi_normal
