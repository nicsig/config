vim9

# Improve this gist to preserve the virtual texts across a buffer reload:
# https://gist.github.com/lacygoill/09da3dddea83e83bc15e6d9a9044bc95
#
# ---
#
# I don't think the structure of `virtualtext_db` makes sense.
# The keys are buffer numbers: that's OK.
# The values are dictionaries of line numbers: that's not OK.
# Instead, the values should be simple lists of names of property types.
# Their positions don't matter; they can change.
# On `BufReadPre`, try  to iterate over the  relevant list (the one  tied to the
# buffer being read); for each name  of property type, run `prop_find()` to find
# where is the virtual text, and other useful info about it.
# On `BufReadPost`, use that info to restore virtual texts.

# FIXME: Doesn't work well when joining lines with virtual texts.
#
# Example: Delete the first  3 lines (the ones which don't  have virtual texts),
# then join the  new first 2 lines  (the one which do have  virtual texts), then
# undo, and finally append  text on the first line: the  inserted text is hidden
# behind the popup.
#
# Update: Actually, can  repro just by  deleting the third line,  then appending
# text on the new 3rd line.

var virtualtext_db: dict<dict<number>> = {}

def AddVirtualText(props: dict<any>): number
    var lnum: number = props.lnum
    var col: number = props.col
    var length: number = props.length
    var text: string = props.text
    var highlight_text: string = has_key(props, 'highlight_text')
        ? props.highlight_text
        : 'Normal'
    var highlight_virtualtext: string = has_key(props, 'highlight_virtualtext')
        ? props.highlight_virtualtext
        : 'Normal'
    if has_key(props, 'highlight_virtualtext')
        highlight_virtualtext = props.highlight_virtualtext
    endif

    var buf: number = bufnr('%')

    if !virtualtext_db->has_key(buf)
        listener_add(UpdatePadding, buf)
    endif

    if prop_type_list({bufnr: buf})->index('virtualText' .. lnum) == -1
        prop_type_add('virtualText' .. lnum, {
            bufnr: buf,
            highlight: highlight_text
            })
    endif
    if has_key(virtualtext_db, buf) && has_key(virtualtext_db[buf], lnum)
        popup_close(virtualtext_db[buf][lnum])
    endif
    prop_add(lnum, col, {
        type: 'virtualText' .. lnum,
        length: length,
        bufnr: buf,
        })

    var left_padding: number = col([lnum, '$']) - length - col + 1

    var popup_id: number = popup_create(text, {
        line: -1,
        padding: [0, 0, 0, left_padding],
        mask: [[1, left_padding, 1, 1]],
        textprop: 'virtualText' .. lnum,
        highlight: highlight_virtualtext,
        fixed: true,
        wrap: false,
        zindex: 50 - 1,
        })
    if !has_key(virtualtext_db, buf)
        extend(virtualtext_db, {[buf->string()]: {}})
    endif
    extend(virtualtext_db[buf], {[lnum->string()]: popup_id})

    augroup PersistAfterReload
        au! * <buffer>
        au BufReadPre <buffer> UpdateDb()
        au BufReadPost <buffer> RefreshHighlighting()
    augroup END

    return popup_id
enddef

def RefreshHighlighting()
    # TODO
enddef

def g:Debug()
    echom virtualtext_db
enddef

def UpdatePadding(buffer: number, start: number, ...l: any)
    if start > line('$')
    || !has_key(virtualtext_db, buffer)
    || !has_key(virtualtext_db[buffer], start)
        return
    endif
    var prop_list: list<dict<any>> = start->prop_list()
    var i: number = prop_list->match('virtualText')
    if i == -1
        return
    endif
    var textprop: dict<any> = prop_list[i]
    var left_padding: number = col([start, '$']) - textprop.length - textprop.col + 1

    var popup_id: number = virtualtext_db[buffer][start]
    popup_setoptions(popup_id, {
        padding: [0, 0, 0, left_padding],
        mask: [[1, left_padding, 1, 1]]
        })
enddef

var lines: list<string> =<< trim END
    I met a traveller from an antique land,
    Who said—“Two vast and trunkless legs of stone
    Stand in the desert. . . . Near them, on the sand,
    Half sunk a shattered visage lies, whose frown,
    And wrinkled lip, and sneer of cold command,
    Tell that its sculptor well those passions read
    Which yet survive, stamped on these lifeless things,
    The hand that mocked them, and the heart that fed;
    And on the pedestal, these words appear:
    My name is Ozymandias, King of Kings;
    Look on my Works, ye Mighty, and despair!
    Nothing beside remains. Round the decay
    Of that colossal Wreck, boundless and bare
    The lone and level sands stretch far away.”
END
setline(1, lines)

var shattered_pos: list<number> = searchpos('shattered', 'n')
AddVirtualText({
    lnum: shattered_pos[0],
    col: shattered_pos[1],
    length: strchars('shattered'),
    text: 'broken into many pieces',
    highlight_text: 'Search',
    highlight_virtualtext: 'MoreMsg',
    })

var sneer_pos: list<number> = searchpos('sneer', 'n')
AddVirtualText({
    lnum: sneer_pos[0],
    col: sneer_pos[1],
    length: strchars('sneer'),
    text: 'a contemptuous or mocking smile, remark, or tone',
    highlight_text: 'Search',
    highlight_virtualtext: 'MoreMsg',
    })

var ozymandias_pos: list<number> = searchpos('Ozymandias', 'n')
AddVirtualText({
    lnum: ozymandias_pos[0],
    col: ozymandias_pos[1],
    length: strchars('Ozymandias'),
    text: 'Greek name for Ramesses II, pharaoh of Egypt',
    highlight_text: 'Search',
    highlight_virtualtext: 'MoreMsg',
    })

var wreck_pos: list<number> = searchpos('Wreck', 'n')
AddVirtualText({
    lnum: wreck_pos[0],
    col: wreck_pos[1],
    length: strchars('Wreck'),
    text: 'something that has been badly damaged or destroyed',
    highlight_text: 'Search',
    highlight_virtualtext: 'MoreMsg',
    })
