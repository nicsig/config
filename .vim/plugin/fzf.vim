if exists('g:loaded_fzf') || stridx(&rtp, 'fzf.vim') == -1
    finish
endif

" For more information about the available settings, read `:h fzf` *and* `:h fzf-vim`.

" Variables{{{1

fu s:snr() abort
    return matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_')
endfu
let s:snr = get(s:, 'snr', s:snr())

" Do *not* use `{'window': 'split'}`!{{{
"
" Otherwise, in  Neovim, when you  invoke an fzf  Ex command (like  `:FZF`), you
" will have 2 windows with an identical terminal buffer.
"}}}
" I have an issue!{{{
"
" See this: https://github.com/junegunn/fzf/issues/1055
"}}}
let g:fzf_layout = {'window': 'call '..s:snr..'create_centered_floating_window()'}
if has('nvim')
    " Source: https://github.com/neovim/neovim/issues/9718#issuecomment-559573308
    fu s:create_centered_floating_window() abort
        " set the width to `&columns - 20`, and make sure it's at least 80 and at most `&columns - 4`
        let width = min([&columns - 4, max([80, &columns - 20])])
        " set the height to `&lines - 10`, and make sure it's at least 20 and at most `&lines - 4`
        let height = min([&lines - 4, max([20, &lines - 10])])
        let top = '┌'..repeat('─', width - 2)..'┐'
        let mid = '│'..repeat(' ', width - 2)..'│'
        let bot = '└'..repeat('─', width - 2)..'┘'
        let lines = [top] + repeat([mid], height - 2) + [bot]
        let config = {
            "\ sets the window layout to "floating",
            "\ place at (row,col) coordinates relative to the global editor grid
            \ 'relative': 'editor',
            \ 'row': ((&lines - height) / 2) - 1,
            \ 'col': (&columns - width) / 2,
            \ 'width': width,
            \ 'height': height,
            "\ display the window with many UI options disabled
            "\ (e.g. 'number', 'cursorline', 'foldcolumn', ...)
            \ 'style': 'minimal',
            \ }
        let box_bufnr = nvim_create_buf(v:false, v:true)
        "                             │        │{{{
        "                             │        └ scratch buffer
        "                             │
        "                             └ not listed ('buflisted' off)
        "}}}
        call nvim_buf_set_lines(box_bufnr, 0, -1, v:true, lines)
        "                                  │   │    │{{{
        "                                  │   │    └ out-of-bounds indices should be an error
        "                                  │   │
        "                                  │   └ up to the last line
        "                                  │
        "                                  │     actually `-1` stands for the index *after* the last line,
        "                                  │     but since this argument is exclusive, here,
        "                                  │     `-1` matches the last line
        "                                  │
        "                                  └ start replacing from the first line
        "}}}
        " open 1st float to get a surrounding box
        let winid = nvim_open_win(box_bufnr, v:false, config)
        call setwinvar(winid, '&winhl', 'Normal:Floating')

        " open 2nd float for fzf to display its info
        let config.row += 1
        let config.height -= 2
        let config.col += 2
        let config.width -= 4
        let winid = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, config)
        "                                                             │
        "                                                             └ enter the window
        "                                                             (to make it the current window)
        call setwinvar(winid, '&winhl', 'Normal:Floating')

        " when the fzf buffer is wiped out, wipe out the surrounding box buffer
        exe 'au BufWipeout <buffer> ++once bw '..box_bufnr
    endfu
else
    fu s:create_centered_floating_window() abort
        " TODO: Implement sth equivalent for Vim.{{{
        "
        " Not possible right now:
        " https://github.com/vim/vim/issues/4063#issuecomment-565808502
        "
        " But it could be in the future.
        "
        " From `:h todo`:
        "
        " >     Popup windows:
        " >     - Make it possible to put a terminal window in a popup.  Would always grab key
        " >       input?  Sort-of possible by creating a hidden terminal and opening a popup
        " >       with that buffer: #4063.
        "}}}
        10new
    endfu
endif

let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ }

" When we use `:[Fz]Buffers`, and we select a buffer which is already displayed
" in a window, give the focus to it, instead of loading it in the current one.
let g:fzf_buffers_jump = 1

let g:fzf_command_prefix = 'Fz'

" Commands{{{1

" How do I toggle the preview window?{{{
"
" Press `?`.
" If you want to use another key:
"
"     fzf#vim#with_preview("right:50%:hidden", "?")
"                                               ^
"                                               change this
"}}}
" Where did you find this command?{{{
"
" For the most part, at the end of `:h fzf-vim-advanced-customization`.
"
" We've also tweaked it to make fzf ignore the first three fields when filtering.
" That is the file path, the line number, and the column number.
" More specifically, we pass to `fzf#vim#with_preview()` this dictionary:
"
"     {"options": "--delimiter=: --nth=4.."}
"
" Which, in turn, pass `--delimiter: --nth=4..` to `fzf(1)`.
"
" See: https://www.reddit.com/r/vim/comments/b88ohz/fzf_ignore_directoryfilename_while_searching/ejwn384/
"}}}
exe 'com -bang -nargs=* '..g:fzf_command_prefix..'Rg
    \ call fzf#vim#grep(
    \   "rg 2>/dev/null --column --line-number --no-heading --color=always --smart-case "..shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview({"options": "--delimiter=: --nth=4.."}, "up:60%")
    \           : fzf#vim#with_preview({"options": "--delimiter=: --nth=4.."}, "right:50%:hidden", "?"),
    \   <bang>0)'

exe 'com -bang -nargs=? -complete=dir '
    \ ..g:fzf_command_prefix..'Files call fzf#vim#files(<q-args>, fzf#vim#with_preview("right:50%"), <bang>0)'

" `:FzSnippets` prints the description of the snippets (✔), but doesn't use it when filtering the results (✘).{{{

" The  issue  is  due to  `:FzSnippets`  which  uses  the  `-n 1`  option  in  the
" `'options'` key of a dictionary.
" To fix this, we replace `-n 1` with `-n ..`.
" From `man fzf`:
"
"     /OPTIONS
"     /Search mode
"     -n, --nth=N[,..]
"           Comma-separated list of field  index expressions for limiting search
"           scope.  See FIELD INDEX EXPRESSION for the details.
"
"     /FIELD INDEX EXPRESSION
"     ..     All the fields
"}}}
exe 'com -bar -bang '..g:fzf_command_prefix..'Snippets call fzf#vim#snippets({"options": "-n .."}, <bang>0)'

" Autocmds{{{1

augroup fzf_open_folds
    au!
    " press `zv` the next time Vim has nothing to do, *after* a buffer has been displayed in a window
    if !has('nvim')
        au FileType fzf au BufWinEnter * ++once au SafeState * ++once norm! zv
    else
        " Why the `mode()` guard?{{{
        "
        " To avoid this issue when we execute an fzf command twice:
        "
        "     Error detected while processing function <lambda>443:
        "     line    1:
        "     Can't re-enter normal mode from terminal mode
        "}}}
        au FileType fzf au BufWinEnter * ++once call timer_start(0, {-> mode() is# 'n' && execute('norm! zv')})
    endif
augroup END

" Mappings{{{1

exe 'nno <silent> <space>fmn :<c-u>'..g:fzf_command_prefix..'Maps<cr>'
nmap <space>fmi i<plug>(fzf-maps-i)
nmap <space>fmx v<plug>(fzf-maps-x)
nmap <space>fmo y<plug>(fzf-maps-o)
" don't press `fm` (search for next `m` character) if we cancel `SPC fm`
nno <space>fm<esc> <nop>

fu s:fuzzy_mappings() abort
    nno <silent> <space>fF :<c-u>FZF $HOME<cr>

    let key2cmd = {
        \ 'M' : 'Marks',
        \ 'R' : 'Rg',
        \ 'bt': 'BTags',
        \ 'c' : 'Commands',
        \ 'f' : 'Files',
        \ 'gf': 'GFiles',
        "\ `gC` for Git Changed files
        \ 'gC': 'GFiles?',
        \ 'h' : 'Helptags',
        "\ `l` for :ls (listing)
        \ 'l' : 'Buffers',
        \ 'r' : 'History',
        "\ `:FzSnippets` only returns snippets whose tab trigger contains the text before the cursor
        \ 's' : 'Snippets',
        \ 't' : 'Tags',
        \ 'w' : 'Windows',
        \ }

    for [char, cmd] in items(key2cmd)
        exe 'nno <silent> <space>f'..char..' :<c-u>'..g:fzf_command_prefix..cmd..'<cr>'
    endfor

    augroup remove_gvfs_from_oldfiles
        au!
        " Rationale:{{{
        "
        " If you've opened ftp files with Vim:
        "
        "     $ gvim ftp://ftp.vim.org/pub/vim/patches/8.0/README
        "
        " `v:oldfiles` will contain filepaths such as:
        "
        "     /run/user/1000/gvfs/ftp:host=ftp.vim.org/pub/vim/patches/8.0/README
        "
        " Those kind of paths make `:FzHistory` slow to start.
        " This is because the command  calls `filereadable()`, and the latter is
        " slow on such a path:
        "
        "     :Time echo filereadable('~/.bashrc')
        "     :Time echo filereadable('/run/user/1000/gvfs/ftp:host=ftp.vim.org/pub/vim/patches/8.0/README')
        "
        " The first command is instantaneous.
        " The second command takes more than a tenth of a second.
        "
        " And the  effect is cumulative: the  more paths like the  previous one,
        " the slower `:FzHistory` opens its fzf window.
        "
        " The value of `v:oldfiles` is built from the viminfo file.
        " The latter is read after our vimrc, so we can't clean `v:oldfiles` right now.
        " We need to wait for Vim to have fully started up.
        "}}}
        au VimEnter * call filter(v:oldfiles, {_,v -> v !~# '/gvfs/'})
    augroup END
endfu
call s:fuzzy_mappings()

nno <silent> <space>fgc :<c-u>call <sid>fuzzy_commits('')<cr>
nno <silent> <space>fgbc :<c-u>call <sid>fuzzy_commits('B')<cr>
fu s:fuzzy_commits(char) abort
    let cwd = getcwd()
    " To use `:FzBCommits` and `:FzCommits`, we first need to be in the working tree of the repo:{{{
    "
    "    - in which the current file belongs
    "
    "    - in which we are interested;
    "      let's say, again, the one where the current file belong
    "}}}
    noa exe 'lcd '..fnameescape(expand('%:p:h'))
    exe g:fzf_command_prefix..a:char..'Commits'
    noa exe 'lcd '..cwd
endfu

" Why not `C-r C-r`?{{{
"
" Already taken (`:h c^r^r`).
"}}}
" Why not `C-r C-r C-r` ?{{{
"
" Would cause a timeout when we press `C-r C-r` to insert a register literally.
"}}}
cno <expr> <c-r><c-h>
\    getcmdtype() =~ ':' ?  '<c-e><c-u>'..g:fzf_command_prefix..'History:<cr>'
\  : getcmdtype() =~ '[/?]' ? '<c-e><c-u><c-c>:'..g:fzf_command_prefix..'History/<cr>' : ''
"                                        ^^^^^
"                                        don't use `<esc>`; an empty pattern would search for the last pattern
"                                        and raise an error if it can't be found

