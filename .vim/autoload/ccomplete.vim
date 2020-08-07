" TODO(mine): Finish refactoring this script in Vim9 script.{{{
"
" If you succeed, suggest the result as a PR.
" And post it as an answer here:
" https://vi.stackexchange.com/questions/26406/how-does-ft-c-omni-work-and-how-can-i-make-it-faster
"}}}
" TODO(mine): try to replace as many `strpart()` as possible; use string slicing instead.{{{
"
"     if strpart(line, start - 1, 1) =~ '\w'
"     ⇔
"     if line[start - 1] =~ '\w'
"
" We can't right now, because of a bug:
"
"     vim9script
"     def Func()
"         let line = 'abc'
"         echo line[1] =~ '\w'
"     enddef
"     Func()
"
"     E1072: Cannot compare number with string~
"
"     vim9script
"     let line = 'abc'
"     echo line[1] =~ '\w'
"     v:true~
"}}}
def ccomplete#Complete(findstart: number, base: string): any #{{{1
    if findstart
        # Locate the start of the item, including ".", "->" and "[...]".
        let line = getline('.')
        let start = col('.') - 1
        let lastword = -1
        while start > 0
            if strpart(line, start - 1, 1) =~ '\w'
                start -= 1
            elseif strpart(line, start - 1, 1) =~ '\.'
                if lastword == -1
                    lastword = start
                endif
                start -= 1
            elseif start > 1 && strpart(line, start - 2, 1) == '-' && strpart(line, start - 1, 1) == '>'
                if lastword == -1
                    lastword = start
                endif
                start -= 2
            elseif strpart(line, start - 1, 1) == ']'
                # Skip over [...].
                let n = 0
                start -= 1
                while start > 0
                    start -= 1
                    if strpart(line, start, 1) == '['
                        if n == 0
                            break
                        endif
                        n -= 1
                    elseif strpart(line, start, 1) == ']'  # nested []
                        n += 1
                    endif
                endwhile
            else
                break
            endif
        endwhile

        # Return the column of the last word, which is going to be changed.
        # Remember the text that comes before it in s:prepended.
        if lastword == -1
            s:prepended = ''
            return start
        endif
        s:prepended = strpart(line, start, lastword - start)
        return lastword
    endif

    # Return list of matches.

    let _base = s:prepended .. base

    # Don't do anything for an empty base, would result in all the tags in the
    # tags file.
    if _base == ''
        return []
    endif

    # init cache for vimgrep to empty
    s:grepCache = {}

    # Split item in words, keep empty word after "." or "->".
    # "aa" -> ['aa'], "aa." -> ['aa', ''], "aa.bb" -> ['aa', 'bb'], etc.
    # We can't use split, because we need to skip nested [...].
    # "aa[...]" -> ['aa', '[...]'], "aa.bb[...]" -> ['aa', 'bb', '[...]'], etc.
    let items = []
    let s = 0
    let arrays = 0
    while 1
        let e = match(_base, '\.\|->\|\[', s)
        if e < 0
            if s == 0 || strpart(_base, s - 1, 1) != ']'
                add(items, strpart(_base, s))
            endif
            break
        endif
        if s == 0 || strpart(_base, s - 1, 1) != ']'
            add(items, strpart(_base, s, e - s))
        endif
        if strpart(_base, e, 1) == '.'
            # skip over '.'
            s = e + 1
        elseif strpart(_base, e, 1) == '-'
            # skip over '->'
            s = e + 2
        else
            # Skip over [...].
            let n = 0
            s = e
            e += 1
            while e < len(_base)
                if strpart(_base, e, 1) == ']'
                    if n == 0
                        break
                    endif
                    n -= 1
                elseif strpart(_base, e, 1) == '['  # nested [...]
                    n += 1
                endif
                e += 1
            endwhile
            e += 1
            add(items, strpart(_base, s, e - s))
            arrays += 1
            s = e
        endif
    endwhile

    # Find the variable items[0].
    # 1. in current function (like with "gd")
    # 2. in tags file(s) (like with ":tag")
    # 3. in current file (like with "gD")
    let res = []
    if searchdecl(items[0], 0, 1) == 0
        # Found, now figure out the type.
        # TODO: join previous line if it makes sense
        let line = getline('.')
        let col = col('.')
        if strpart(line, 0, col)->stridx(';') != -1
            # Handle multiple declarations on the same line.
            let col2 = col - 1
            while strpart(line, col2, 1) != ';'
                col2 -= 1
            endwhile
            line = strpart(line, col2 + 1)
            col -= col2
        endif
        if strpart(line, 0, col)->stridx(',') != -1
            # Handle multiple declarations on the same line in a function
            # declaration.
            let col2 = col - 1
            while strpart(line, col2, 1) != ','
                col2 -= 1
            endwhile
            if strpart(line, col2 + 1, col - col2 - 1) =~ ' *[^ ][^ ]*  *[^ ]'
                line = strpart(line, col2 + 1)
                col -= col2
            endif
        endif
        if len(items) == 1
            # Completing one word and it's a local variable: May add '[', '.' or
            # '->'.
            let match = items[0]
            let kind = 'v'
            if match(line, '\<' .. match .. '\s*\[') > 0
                match ..= '['
            else
                res = Nextitem(strpart(line, 0, col), [''], 0, 1)
                if len(res) > 0
                    # There are members, thus add "." or "->".
                    if match(line, '\*[ \t(]*' .. match .. '\>') > 0
                        match ..= '->'
                    else
                        match ..= '.'
                    endif
                endif
            endif
            res = [{'match': match, 'tagline' : '', 'kind' : kind, 'info' : line}]
        elseif len(items) == arrays + 1
            # Completing one word and it's a local array variable: build tagline
            # from declaration line
            let match = items[0]
            let kind = 'v'
            let tagline = "\t/^" .. line .. '$/'
            res = [{'match': match, 'tagline' : tagline, 'kind' : kind, 'info' : line}]
        else
            # Completing "var.", "var.something", etc.
            let _items = deepcopy(items)
            remove(_items, 0)
            res = Nextitem(strpart(line, 0, col), _items, 0, 1)
        endif
    endif

    if len(items) == 1 || len(items) == arrays + 1
        # Only one part, no "." or "->": complete from tags file.
        let tags: list<dict<any>>
        if len(items) == 1
            tags = taglist('^' .. _base)
        else
            tags = taglist('^' .. items[0] .. '$')
        endif

        # Remove members, these can't appear without something in front.
        filter(tags, {_, v -> has_key(v, 'kind') ? v.kind != 'm' : 1})

        # Remove static matches in other files.
        filter(tags, {_, v -> !has_key(v, 'static') || !v['static'] || bufnr('%') == bufnr(v['filename'])})

        extend(res, map(tags, {_, v -> Tag2item(v)}))
    endif

    if len(res) == 0
        # Find the variable in the tags file(s)
        let diclist = taglist('^' .. items[0] .. '$')

        # Remove members, these can't appear without something in front.
        filter(diclist, {_, v -> has_key(v, 'kind') ? v.kind != 'm' : 1})

        res = []
        for i in len(diclist)->range()
            # New ctags has the "typeref" field.  Patched version has "typename".
            if has_key(diclist[i], 'typename')
                let _items = deepcopy(items)
                remove(_items, 0)
                extend(res, s:StructMembers(diclist[i]['typename'], _items, 1))
            elseif has_key(diclist[i], 'typeref')
                let _items = deepcopy(items)
                remove(_items, 0)
                extend(res, s:StructMembers(diclist[i]['typeref'], _items, 1))
            endif

            # For a variable use the command, which must be a search pattern that
            # shows the declaration of the variable.
            if diclist[i]['kind'] == 'v'
                let line = diclist[i]['cmd']
                if strpart(line, 0, 2) ==# '/^'
                    let col = match(line, '\<' .. items[0] .. '\>')
                    let _items = deepcopy(items)
                    remove(_items, 0)
                    extend(res, Nextitem(strpart(line, 2, col - 2), _items, 0, 1))
                endif
            endif
        endfor
    endif

    if len(res) == 0 && searchdecl(items[0], 1) == 0
        # Found, now figure out the type.
        # TODO: join previous line if it makes sense
        let line = getline('.')
        let col = col('.')
        let _items = deepcopy(items)
        remove(_items, 0)
        res = Nextitem(strpart(line, 0, col), _items, 0, 1)
    endif

    # If the last item(s) are [...] they need to be added to the matches.
    let last = len(items) - 1
    let brackets = ''
    while last >= 0
        if strpart(items[last], 0, 1) != '['
            break
        endif
        brackets = items[last] .. brackets
        last -= 1
    endwhile

    return map(res, {_, v -> Tagline2item(v, brackets)})
enddef

def GetAddition(line: string, match: string, memarg: list<dict<any>>, bracket: bool): string #{{{1
    # Guess if the item is an array.
    if bracket && match(line, match .. '\s*\[') > 0
        return '['
    endif

    # Check if the item has members.
    if SearchMembers(memarg, [''], 0)->len() > 0
        # If there is a '*' before the name use "->".
        if match(line, '\*[ \t(]*' .. match .. '\>') > 0
            return '->'
        else
            return '.'
        endif
    endif
    return ''
enddef

def Tag2item(val: dict<any>) #{{{1
    # Turn the tag info "val" into an item for completion.
    # "val" is is an item in the list returned by taglist().
    # If it is a variable we may add "." or "->".  Don't do it for other types,
    # such as a typedef, by not including the info that GetAddition() uses.
    let res = {'match': val['name']}

    res['extra'] = Tagcmd2extra(val['cmd'], val['name'], val['filename'])

    let s = Dict2info(val)
    if s != ''
        res['info'] = s
    endif

    res['tagline'] = ''
    if has_key(val, "kind")
        let kind = val['kind']
        res['kind'] = kind
        if kind == 'v'
            res['tagline'] = "\t" .. val['cmd']
            res['dict'] = val
        elseif kind == 'f'
            res['match'] = val['name'] .. '('
        endif
    endif

    return res
enddef

def Dict2info(dict: dict<any>): string #{{{1
    # Use all the items in dictionary for the "info" entry.
    let info = ''
    for k in keys(dict)->sort()
        info  ..= k .. repeat(' ', 10 - len(k))
        if k == 'cmd'
            info ..= matchstr(dict['cmd'], '/^\s*\zs.*\ze$/')->substitute('\\\(.\)', '\1', 'g')
        else
            let dictk = dict[k]
            if type(dictk) != v:t_string
                info ..= string(dictk)
            else
                info ..= dictk
            endif
        endif
        info ..= "\n"
    endfor
    return info
enddef

fu s:ParseTagline(line) abort "{{{1
    " Parse a tag line and return a dictionary with items like taglist()
    let l = split(a:line, "\t")
    let d = {}
    if len(l) >= 3
        let d['name'] = l[0]
        let d['filename'] = l[1]
        let d['cmd'] = l[2]
        let n = 2
        if l[2] =~ '^/'
            " Find end of cmd, it may contain Tabs.
            while n < len(l) && l[n] !~ '/;"$'
                let n += 1
                let d['cmd'] ..= '  ' .. l[n]
            endwhile
        endif
        for i in range(n + 1, len(l) - 1)
            if l[i] == 'file:'
                let d['static'] = 1
            elseif l[i] !~ ':'
                let d['kind'] = l[i]
            else
                let d[matchstr(l[i], '[^:]*')] = matchstr(l[i], ':\zs.*')
            endif
        endfor
    endif

    return d
endfu

def Tagline2item(val: dict<any>, brackets: string): dict<any> #{{{1
    # Turn a match item "val" into an item for completion.
    # "val['match']" is the matching item.
    # "val['tagline']" is the tagline in which the last part was found.
    let line = val['tagline']
    let add = GetAddition(line, val['match'], [val], brackets == '')
    let res = {'word': val['match'] .. brackets .. add }

    if has_key(val, 'info')
        # Use info from Tag2item().
        res['info'] = val['info']
    else
        # Parse the tag line and add each part to the "info" entry.
        let s = s:ParseTagline(line)->Dict2info()
        if s != ''
            res['info'] = s
        endif
    endif

    if has_key(val, 'kind')
        res['kind'] = val['kind']
    elseif add == '('
        res['kind'] = 'f'
    else
        let s = matchstr(line, '\t\(kind:\)\=\zs\S\ze\(\t\|$\)')
        if s != ''
            res['kind'] = s
        endif
    endif

    if has_key(val, 'extra')
        res['menu'] = val['extra']
        return res
    endif

    # Isolate the command after the tag and filename.
    let s = matchstr(line, '[^\t]*\t[^\t]*\t\zs\(/^.*$/\|[^\t]*\)\ze\(;"\t\|\t\|$\)')
    if s != ''
        res['menu'] = Tagcmd2extra(s, val['match'], matchstr(line, '[^\t]*\t\zs[^\t]*\ze\t'))
    endif
    return res
enddef

def Tagcmd2extra(cmd: string, name: string, fname: string): string #{{{1
    # Turn a command from a tag line to something that is useful in the menu
    let x: string
    if cmd =~ '^/^'
        # The command is a search command, useful to see what it is.
        x = matchstr(cmd, '^/^\s*\zs.*\ze$/')
        x = substitute(x, '\<' .. name .. '\>', '@@', '')
        x = substitute(x, '\\\(.\)', '\1', 'g')
        x = x .. ' - ' .. fname
    elseif cmd =~ '^\d*$'
        # The command is a line number, the file name is more useful.
        x = fname .. ' - ' .. cmd
    else
        # Not recognized, use command and file name.
        x = cmd .. ' - ' .. fname
    endif
    return x
enddef

def Nextitem(lead: string, items: list<any>, depth: number, all: number): list<string> #{{{1
    # Find composing type in "lead" and match items[0] with it.
    # Repeat this recursively for items[1], if it's there.
    # When resolving typedefs "depth" is used to avoid infinite recursion.
    # Return the list of matches.

    # Use the text up to the variable name and split it in tokens.
    let tokens = split(lead, '\s\+\|\<')

    # Try to recognize the type of the variable.  This is rough guessing...
    let res = []
    for tidx in len(tokens)->range()

        # Skip tokens starting with a non-ID character.
        if tokens[tidx] !~ '^\h'
            continue
        endif

        # Recognize "struct foobar" and "union foobar".
        # Also do "class foobar" when it's C++ after all (doesn't work very well
        # though).
        if (tokens[tidx] == 'struct' || tokens[tidx] == 'union' || tokens[tidx] == 'class') && tidx + 1 < len(tokens)
            res = s:StructMembers(tokens[tidx] .. ':' .. tokens[tidx + 1], items, all)
            break
        endif

        # TODO: add more reserved words
        if index(['int', 'short', 'char', 'float', 'double', 'static', 'unsigned', 'extern'], tokens[tidx]) >= 0
            continue
        endif

        # Use the tags file to find out if this is a typedef.
        let diclist = taglist('^' .. tokens[tidx] .. '$')
        for tagidx in len(diclist)->range()
            let item = diclist[tagidx]

            # New ctags has the "typeref" field.  Patched version has "typename".
            if has_key(item, 'typeref')
                extend(res, s:StructMembers(item['typeref'], items, all))
                continue
            endif
            if has_key(item, 'typename')
                extend(res, s:StructMembers(item['typename'], items, all))
                continue
            endif

            # Only handle typedefs here.
            if item['kind'] != 't'
                continue
            endif

            # Skip matches local to another file.
            if has_key(item, 'static') && item['static'] && bufnr('%') != bufnr(item['filename'])
                continue
            endif

            # For old ctags we recognize "typedef struct aaa" and
            # "typedef union bbb" in the tags file command.
            let cmd = item['cmd']
            let ei = matchend(cmd, 'typedef\s\+')
            if ei > 1
                let cmdtokens = strpart(cmd, ei)->split('\s\+\|\<')
                if len(cmdtokens) > 1
                    if cmdtokens[0] == 'struct' || cmdtokens[0] == 'union' || cmdtokens[0] == 'class'
                        let name = ''
                        # Use the first identifier after the "struct" or "union"
                        for ti in (len(cmdtokens) - 1)->range()
                            if cmdtokens[ti] =~ '^\w'
                                name = cmdtokens[ti]
                                break
                            endif
                        endfor
                        if name != ''
                            extend(res, s:StructMembers(cmdtokens[0] .. ':' .. name, items, all))
                        endif
                    elseif depth < 10
                        # Could be "typedef other_T some_T".
                        extend(res, Nextitem(cmdtokens[0], items, depth + 1, all))
                    endif
                endif
            endif
        endfor
        if len(res) > 0
            break
        endif
    endfor

    return res
enddef

fu s:StructMembers(typename, items, all) abort "{{{1
    " New header when you refactor in Vim9 script:{{{
    "
    "     def StructMembers(typename: string, items: list<any>, all: number): list<dict<any>>
    "                                                     ^-^
    "                                                     yes: any; not string
    "}}}

    " Search for members of structure "typename" in tags files.
    " Return a list with resulting matches.
    " Each match is a dictionary with "match" and "tagline" entries.
    " When "all" is non-zero find all, otherwise just return 1 if there is any
    " member.

    " Todo: What about local structures?
    let fnames = tagfiles()->map('escape(v:val, " \\#%")')->join()
    if fnames == ''
        return []
    endif

    let typename = a:typename
    let qflist = []
    let cached = 0
    if a:all == 0
        let n = '1' " stop at first found match
        if has_key(s:grepCache, a:typename)
            let qflist = s:grepCache[a:typename]
            let cached = 1
        endif
    else
        let n = ''
    endif
    if !cached
        while 1
            exe 'silent! keepj noautocmd ' .. n .. 'vimgrep /\t' .. typename .. '\(\t\|$\)/j ' .. fnames

            let qflist = getqflist()
            if len(qflist) > 0 || match(typename, "::") < 0
                break
            endif
            " No match for "struct:context::name", remove "context::" and try again.
            let typename = substitute(typename, ':[^:]*::', ':', '')
        endwhile

        if a:all == 0
            " Store the result to be able to use it again later.
            " TODO(mine): When you'll refactor this function in a `:def` function:{{{
            "
            " you'll  probably  need  to   have  created  a  secondary  variable
            " `_typename`  initialized by  `typename`.   Here is  what the  code
            " should probably look like around:
            "
            "     let _typename: string
            "     while 1
            "       exe 'silent! keepj noautocmd ' .. n .. 'vimgrep /\t' .. typename .. '\(\t\|$\)/j ' .. fnames
            "       qflist = getqflist()
            "       if len(qflist) > 0 || match(typename, "::") < 0
            "         break
            "       endif
            "       _typename = substitute(typename, ':[^:]*::', ':', '')
            "     endwhile
            "     if all == 0
            "       s:grepCache[_typename] = qflist
            "     endif
            " }}}
            let s:grepCache[a:typename] = qflist
        endif
    endif

    " Skip over [...] items
    let idx = 0
    while 1
        if idx >= len(a:items)
            let target = ''           " No further items, matching all members
            break
        endif
        if a:items[idx][0] != '['
            let target = a:items[idx]
            break
        endif
        let idx += 1
    endwhile
    " Put matching members in matches[].
    let matches = []
    for l in qflist
        let memb = matchstr(l['text'], '[^\t]*')
        if memb =~ '^' .. target
            " Skip matches local to another file.
            if match(l['text'], "\tfile:") < 0 || bufnr('%') == matchstr(l['text'], '\t\zs[^\t]*')->bufnr()
                let item = {'match': memb, 'tagline': l['text']}

                " Add the kind of item.
                let s = matchstr(l['text'], '\t\(kind:\)\=\zs\S\ze\(\t\|$\)')
                if s != ''
                    let item['kind'] = s
                    if s == 'f'
                        let item['match'] = memb .. '('
                    endif
                endif

                call add(matches, item)
            endif
        endif
    endfor

    if len(matches) > 0
        " Skip over next [...] items
        let idx += 1
        while 1
            if idx >= len(a:items)
                return matches          " No further items, return the result.
            endif
            if a:items[idx][0] != '['
                break
            endif
            let idx += 1
        endwhile

        " More items following.  For each of the possible members find the
        " matching following members.
        " TODO(mine): We can't refactor this function until Vim9 script supports list slicing.{{{
        "
        "     return SearchMembers(matches, a:items[idx :], a:all)
        "                                          ^-----^
        "
        " I tried to emulate the latter construct with a `map()`, but it didn't work
        " as expected; there were a bunch of errors which were raised from seemingly
        " somewhere else.  Also, tried with `:for` + `add()`...
        "
        " It could be due to our `map()` or to yet another part of the script.
        " Anyway, there's no rush.  Let's wait for Vim9 to get more reliable, and at
        " least support list slicing.
        "}}}
        return SearchMembers(matches, a:items[idx :], a:all)
    endif

    " Failed to find anything.
    return []
endfu

def SearchMembers(matches: list<dict<any>>, items: list<string>, all: number): list<any> #{{{1
    # TODO(mine): Should the function return type be `list<string>` instead?
    # Or maybe `list<dict<any>>`?

    # For matching members, find matches for following items.
    # When "all" is non-zero find all, otherwise just return 1 if there is any
    # member.
    let res = []
    for i in len(matches)->range()
        let typename = ''
        let line: string
        if has_key(matches[i], 'dict')
            if has_key(matches[i].dict, 'typename')
                typename = matches[i].dict['typename']
            elseif has_key(matches[i].dict, 'typeref')
                typename = matches[i].dict['typeref']
            endif
            line = "\t" .. matches[i].dict['cmd']
        else
            line = matches[i]['tagline']
            let e = matchend(line, '\ttypename:')
            if e < 0
                e = matchend(line, '\ttyperef:')
            endif
            if e > 0
                # Use typename field
                typename = matchstr(line, '[^\t]*', e)
            endif
        endif

        if typename != ''
            extend(res, s:StructMembers(typename, items, all))
        else
            # Use the search command (the declaration itself).
            let s = match(line, '\t\zs/^')
            if s > 0
                let e = match(line, '\<' .. matches[i]['match'] .. '\>', s)
                if e > 0
                    extend(res, Nextitem(strpart(line, s, e - s), items, 0, all))
                endif
            endif
        endif
        if all == 0 && len(res) > 0
            break
        endif
    endfor
    return res
enddef
