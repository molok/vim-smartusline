" smartusline.vim
" ---------------------------------------------------------------
" Version:  0.3
" Authors: Alessio 'molok' Bolognino <alessio.bolognino+vim@gmail.com>
" Last Modified: 2012-01-20
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

let g:loaded_smartusline = 0.3
let s:keepcpo         = &cpo
set cpo&vim

let s:def_cterm_replace = ''
let s:def_cterm_normal  = ''
let s:def_cterm_insert  = ''

if (&t_Co > 0)
    if (&t_Co <= 16)
        let s:def_cterm_replace = 'ctermfg=black ctermbg=13'
        let s:def_cterm_normal  = 'ctermfg=black ctermbg=10'
        let s:def_cterm_insert  = 'ctermfg=white ctermbg=9'
    elseif (&t_Co <= 88)
        let s:def_cterm_replace = 'ctermfg=black ctermbg=13'
        let s:def_cterm_normal  = 'ctermfg=black ctermbg=82'
        let s:def_cterm_insert  = 'ctermfg=white ctermbg=9'
    elseif (&t_Co <= 256)
        let s:def_cterm_replace = 'ctermfg=black ctermbg=169'
        let s:def_cterm_normal  = 'ctermfg=black ctermbg=113'
        let s:def_cterm_insert  = 'ctermfg=black ctermbg=214'
    endif
endif

if !exists('g:smartusline_hi_replace')
    let g:smartusline_hi_replace = 'guibg=#e454ba guifg=black ' . s:def_cterm_replace
endif

if !exists('g:smartusline_hi_insert')
    let g:smartusline_hi_insert = 'guibg=orange guifg=black ' . s:def_cterm_insert
endif

if !exists('g:smartusline_hi_virtual_replace')
    let g:smartusline_hi_virtual_replace = 'guibg=#e454ba guifg=black ' . s:def_cterm_replace
endif

if !exists('g:smartusline_hi_normal')
    let g:smartusline_hi_normal = 'guibg=#95e454 guifg=black ' . s:def_cterm_normal
endif

if !exists('g:smartusline_deep_eval')
    let g:smartusline_deep_eval = 0
endif

execute 'hi StatColor ' . g:smartusline_hi_normal

if !exists('g:smartusline_string_to_highlight')
    let g:smartusline_string_to_highlight = '%f'
endif

let s:open_hi = '%#StatColor#'
let s:close_hi = '%*'

function! SmartusLineWin(mode)

    let curr_stl = &stl
    let new_stl = ""

    let curr_stl = s:EvalSTL(curr_stl, g:smartusline_deep_eval)

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
        let &l:stl = new_stl
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

augroup SmartusLine
    au WinLeave * call SmartusLineWin('Leave')
    au WinEnter,BufEnter,VimEnter * call SmartusLineWin('Enter')

    au InsertLeave * call SmartusLineInsert('Leave')
    au InsertEnter * call SmartusLineInsert('Enter')
    au InsertChange * call SmartusLineInsert('Enter')

    " this shouldn't be needed, but it is
    au GUIEnter * execute 'hi StatColor ' g:smartusline_hi_normal
augroup END

fun! s:EvalSTL(stl_to_eval, deep_eval)
    if match(a:stl_to_eval, '^%!') >= 0
        let str = eval(a:stl_to_eval[2:-1])
    else
        let str = a:stl_to_eval
    endif
    if a:deep_eval == 0
        return str
    endif
    let prev_out = '0'
    let out = '1'

    " if out == prev_out then I don't have anything else to evaluate
    while out != prev_out
        let in_quote = 0
        let in_dquote = 0
        let in_fun = 0
        let prev_was_perc = 0
        let start_fun = -1

        let out = ''
        let i = 0

        while i < len(str)
            if str[i] == "'" && !in_dquote
                let in_quote = !in_quote
            endif

            if str[i] == '"' && !in_quote
                let in_dquote = !in_dquote
            endif

            if prev_was_perc == 1
                if str[i] == '{' && !in_quote && !in_dquote
                    let in_fun = 1
                    let start_fun = i+1
                else
                    if !in_fun
                        let out .= '%'
                    endif
                endif
                let prev_was_perc = 0
            endif

            if str[i] == '}' && in_fun && !in_quote && !in_dquote
                let in_fun = 0
                let fun_to_eval = str[start_fun : i-1]
                let out .= eval(fun_to_eval)
            elseif str[i] != '%'
                if !in_fun
                    let out .= str[i]
                endif
            else
                let prev_was_perc = 1
            endif
            let i = i+1
        endwhile
        let prev_out = out
    endwhile

    return out

endfunction
