if has('nvim')
    " Source: https://github.com/junegunn/fzf/blob/master/README-VIM.md#starting-fzf-in-neovim-floating-window
    fu plugin#fzf#window(width, height, border_highlight) abort
        " Size and position
        let width = float2nr(&columns * a:width)
        let height = float2nr(&lines * a:height)
        let row = float2nr((&lines - height) / 2)
        let col = float2nr((&columns - width) / 2)

        " Border
        let top = '┌' . repeat('─', width - 2) . '┐'
        let mid = '│' . repeat(' ', width - 2) . '│'
        let bot = '└' . repeat('─', width - 2) . '┘'
        let border = [top] + repeat([mid], height - 2) + [bot]

        " Draw frame
        let frame = s:create_float(a:border_highlight, {
            \ 'row': row,
            \ 'col': col,
            \ 'width': width,
            \ 'height': height,
            \ })
        call nvim_buf_set_lines(frame, 0, -1, v:true, border)
        "                              │   │  │{{{
        "                              │   │  └ out-of-bounds indices should be an error
        "                              │   │
        "                              │   └ up to the last line
        "                              │
        "                              │     actually `-1` stands for the index *after* the last line,
        "                              │     but since this argument is exclusive, here,
        "                              │     `-1` matches the last line
        "                              │
        "                              └ start replacing from the first line
        " }}}

        " Draw viewport
        call s:create_float('Normal', {
            \ 'row': row + 1,
            \ 'col': col + 2,
            \ 'width': width - 4,
            \ 'height': height - 2,
            \ })
        " Wipe frame buffer when viewport is quit
        exe 'au BufWipeout <buffer> bw '..frame
    endfu

    fu s:create_float(hl, opts) abort
        "                         ┌ not listed ('buflisted' off){{{
        "                         │        ┌ scratch buffer
        "                         │        │}}}
        let buf = nvim_create_buf(v:false, v:true)
        " What's the effect of `relative: editor`?{{{
        "
        " It sets the window layout to "floating", placed at (row,col) coordinates
        " relative to the global editor grid.
        "}}}
        "   What about `style: minimal`?{{{
        "
        " It displays  the window  with many UI  options disabled  (e.g. 'number',
        " 'cursorline', 'foldcolumn', ...).
        "}}}
        let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
        let win = nvim_open_win(buf, v:true, opts)
        "                            │{{{
        "                            └ enter the window (to make it the current window)
        "}}}
        call setwinvar(win, '&winhighlight', 'NormalFloat:'..a:hl)
        return buf
    endfu
else
    fu plugin#fzf#window(width, height, border_highlight) abort
        let width = float2nr(&columns * a:width)
        let height = float2nr(&lines * a:height)
        let line = ((&lines - height) / 2) -1 + 1
        let col = (&columns - width) / 2 + 2

        let top = '┌' . repeat('─', width - 2) . '┐'
        let mid = '│' . repeat(' ', width - 2) . '│'
        let bot = '└' . repeat('─', width - 2) . '┘'
        let border = [top] + repeat([mid], height - 2) + [bot]

        let frame = s:create_popup_window(a:border_highlight, {
            \ 'line': line,
            \ 'col': col,
            \ 'width': width,
            \ 'height': height,
            \ 'is_frame': 1,
            \ })
        call setbufline(frame, 1, border)

        call s:create_popup_window('Normal', {
            \ 'line': line + 1,
            \ 'col': col + 2,
            \ 'width': width - 4,
            \ 'height': height - 2,
            \ })
    endfu

    fu s:create_popup_window(hl, opts) abort
        if has_key(a:opts, 'is_frame')
            let id = popup_create('', #{
                \ line: a:opts.line,
                \ col: a:opts.col,
                \ minwidth: a:opts.width,
                \ minheight: a:opts.height,
                \ zindex: 50,
                \ })
            call setwinvar(id, '&wincolor', a:hl)
            exe 'au BufWipeout * ++once call popup_close('..id..')'
            return winbufnr(id)
        else
            let buf = term_start(&shell, #{hidden: 1})
            call popup_create(buf, #{
                \ line: a:opts.line,
                \ col: a:opts.col,
                \ minwidth: a:opts.width,
                \ minheight: a:opts.height,
                \ zindex: 51,
                \ })
            exe 'au BufWipeout * ++once bw! '..buf
        endif
    endfu
endif

