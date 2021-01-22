vim9

# https://vi.stackexchange.com/questions/28826/can-you-do-a-jagged-visual-selection-or-jagged-yank

var lines: list<string> =<< trim END
    sadf_blahbalh_sdf+foo-bar
    sadf_abc_zzz+foo-bar
    asdf_yx_sdf+foo-bar
END
setline(1, lines)
norm! f_
xno <c-g><c-g> <cmd>call <sid>VisualJaggedMode()<cr>
def VisualJaggedMode()
    if mode() != "\<c-v>"
        exe "norm! \<c-v>"
    endif
    exe "norm! \e"
    redraw
    jagged_selection = []
    var first_col: number = col("'<")
    var last_col: number = col("'>")
    for lnum in range(line("'<"), line("'>"))
        jagged_selection += [[lnum, first_col, last_col]]
    endfor
    curbuf = bufnr('%')
    UpdateHighlighting()
    popup_bufnr = popup_create('-- VISUAL JAGGED BLOCK --', {
        line: &lines,
        col: 1,
        highlight: 'ModeMsg',
        filter: Filter,
        mapping: false,
        })->winbufnr()
    exe printf('au BufWinLeave <buffer=%d> ++once ClearJaggedSelection()', popup_bufnr)
    feedkeys("\<CursorHold>")
enddef
var popup_bufnr: number
var curbuf: number

def UpdateHighlighting(key = '')
    ClearJaggedSelection()
    if key != ''
        for i in jagged_selection
            var n: number = i[0]
                ->getline()
                ->matchend('.*\%' .. col("'<") .. 'c.\{-1,}' .. key)
            if n != -1
                i[2] = n
            endif
        endfor
    endif
    for [lnum, col_start, col_end] in jagged_selection
        prop_add(lnum, col_start, {
            type: 'JaggedSelection',
            length: col_end - col_start + 1,
            bufnr: curbuf,
            })
    endfor
enddef

def Filter(winid: number, key: string): bool
    if key == 'y'
        eval jagged_selection
            ->mapnew((_, v) => v[0]
                ->getline()
                ->matchstr('\%' .. v[1] .. 'c.*\%' .. v[2] .. 'c.')
            )->setreg('"', 'b')
        popup_close(winid)
        return true
    elseif key == 'd' || key == 'c'
        eval jagged_selection
            ->mapnew((_, v) => v[0]
                ->getline()
                ->substitute('\%' .. v[1] .. 'c.*\%' .. v[2] .. 'c.', '', '')
            )->setline(line("'<"))
        popup_close(winid)
        if key == 'c'
            feedkeys('i', 'nt')
        endif
        return true
    # TODO: If we press `v`, we should leave the submode, and enter visual characterwise mode.
    elseif index(['v', 'V', "\<c-v>"], key) >= 0
        popup_close(winid)
        # Why twice?  Is it reliable?
        feedkeys(key .. key, 'nt')
    # TODO: We should be able to select up to a character, without including it.
    elseif key =~ '^\p$'
        UpdateHighlighting(key)
        return true
    elseif key == "\<c-x>"
    endif
    # TODO: If we press `C-g`, we should leave the submode, and get back to normal mode.
    # TODO: If we press `C-v`, we should leave the submode, and enter visual block mode.
    # TODO: If we press `V`, we should leave the submode, and enter visual line mode.
    # TODO: If  we control  a  left  corner (top  or  bottom),  when pressing  a
    # printable character, the latter should  be looked for backward, instead of
    # forward.
    return popup_filter_menu(winid, key)
enddef

def ClearJaggedSelection()
    prop_type_delete('JaggedSelection', {bufnr: curbuf})
    var lnum_start: number = jagged_selection[0][0]
    var lnum_end: number = jagged_selection[-1][0]
    prop_clear(lnum_start, lnum_end, {
        bufnr: curbuf,
        type: 'JaggedSelection',
        })
    prop_type_add('JaggedSelection', {
        bufnr: curbuf,
        highlight: 'Visual'
        })
enddef

var jagged_selection: list<list<number>>
