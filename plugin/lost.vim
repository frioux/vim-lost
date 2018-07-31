" lost.vim - I'm all lost in this file
" Maintainer:   Arthur Axel fREW Schmidt <https://blog.afoolishmanifesto.com/>
" Version:      0.9

if exists('g:loaded_lost') || &cp || v:version < 700
  finish
endif
let g:loaded_lost = 1

function! Lost_get_regex()
    return get(b:, 'lost_regex', '\v^[[:alpha:]$_]')
endfunction

function! Lost_string()
  " https://git.savannah.gnu.org/cgit/diffutils.git/tree/src/diff.c?id=eaa2a24#n464
  let re = Lost_get_regex()
  let found = search(re, "bn", 1, 100)
  if found > 0
     let line = getline(found)
     return line
  else
     return '?'
  endif
endfunction

function! Lost_movement(mode, search_type)
    let old_wrapscan = &wrapscan
    set nowrapscan
    if a:mode ==# 'visual'
        normal! gv
    endif
    silent! execute 'normal! ' . a:search_type . "\<C-r>=Lost_get_regex()\<CR>\<CR>"
    let &wrapscan = old_wrapscan
endfunction

function! Lost_mapping()
    nnoremap <silent> ]gL :<C-u>call Lost_movement('normal', '/')<CR>
    nnoremap <silent> [gL :<C-u>call Lost_movement('normal', '?')<CR>
    xnoremap <silent> ]gL :<C-u>call Lost_movement('visual', '/')<CR>
    xnoremap <silent> [gL :<C-u>call Lost_movement('visual', '?')<CR>
endfunction

augroup Lost
    autocmd!
    autocmd BufEnter * call Lost_mapping()
augroup END


command! -bar Lost echom Lost_string()

nnoremap <silent> gL :Lost<Cr>
