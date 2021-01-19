vim9

# Where does the code in this script come from?{{{
#
#     $VIMRUNTIME/syntax/hitest.vim
#}}}
# What does it do?{{{
#
# Print your current highlight groups.
# And for each, list all the syntax groups which are linked to it.
#}}}
# Why don't you use the original script?{{{
#
# It contains a few errors:
#
#    - `:normal` instead of `normal!`
#     (which causes an issue because of a custom mapping installed by `vim-search`)
#
#    - doesn't temporarily reset `'ww'`
#    (which causes an issue because we do `set ww=h,l` in our vimrc)
#}}}

var options_save: dict<any>

def Hitest() #{{{1
    OptionsSave()
    OptionsSet()

    # Open a new window if the current one isn't empty
    if line('$') != 1 || getline(1) != ''
        new
    endif

    sil exe 'edit ' .. tempname()

    setl noswf noet sw=16 ts=16
    &l:tw = &columns

    # insert highlight settings
    keepj :%d _
    execute('hi')->split('\n')->setline(1)

    # remove the colored xxx items
    keepj keepp :%s/xxx//e

    # remove color settings (not needed here)
    keepj keepp v/links to/ keepj keepp s/\s.*$//e

    # move linked groups to the end of file
    keepj keepp g/links to/m $

    # reverse order in the links:{{{
    #
    #     markdownH1      links to Title
    #     →
    #     Title	links to markdownH1
    #}}}
    keepj keepp :%s/^\(\w\+\)\s*\(links to\)\s*\(\w\+\)$/\3\t\2 \1/e
    # group all the syntax groups which are linked to the same HG on the same line
    keepj keepp g/links to/keepp norm! mz3ElD0#$p'zdd
    #                                  ├┘├─┘│││├┘├┘├┘{{{
    #                                  │ │  ││││ │ └ we don't this line anymore, remove it
    #                                  │ │  ││││ │
    #                                  │ │  ││││ └ get back where we were
    #                                  │ │  ││││
    #                                  │ │  │││└ paste the syntax group at the end of the line
    #                                  │ │  │││
    #                                  │ │  │││  we're progressively building the set of syntax groups
    #                                  │ │  │││  which are linked to the same HG:
    #                                  │ │  │││
    #                                  │ │  │││          Title
    #                                  │ │  │││          Title MarkdownH1
    #                                  │ │  │││          Title MarkdownH1 MarkdownH2
    #                                  │ │  │││          ...
    #                                  │ │  │││
    #                                  │ │  ││└ move to the previous occurrence of the syntax group name
    #                                  │ │  ││
    #                                  │ │  │└ the syntax group we've just deleted is linked to a HG (e.g. `Title`)
    #                                  │ │  │  move to the beginning of the line, where the latter is written
    #                                  │ │  │
    #                                  │ │  └ delete the syntax group name
    #                                  │ │
    #                                  │ └ move to the beginning of the syntax group name
    #                                  │   (e.g. `markdownH1`)
    #                                  │
    #                                  └ remember where we are
    #}}}

    # delete empty lines
    keepj keepp g/^ *$/d _

    # precede syntax command
    keepj keepp :%s/^[^ ]*/syn keyword &\t&/

    # execute syntax commands
    syn clear | sil update | so % | setl bt=nofile

    # remove syntax commands again
    keepj keepp :%s/^syn keyword //

    PrettyFormatting()
    OptionsRestore()
enddef

def PrettyFormatting() #{{{1
    keepj keepp g/^/exe "norm! Wi\r\t\egww"
    keepj keepp g/^\S/j

    # find out first syntax highlighting
    var various: string = &highlight .. ',:Normal,:Cursor,:,'
    var i: number = 1
    while various =~ ':' .. getline(i)->substitute('\s.*$', ',', '')
        i += 1
        if i > line('$')
            break
        endif
    endwhile

    # insert headlines
    append(0, ['Highlight groups for various occasions', '--------------------------------------'])

    if i < line('$') - 1
        append(i + 1, ['', 'Syntax highlighting groups', '--------------------------'])
    endif

    cursor(1, 1)
enddef

def OptionsSave() #{{{1
    options_save.report = &report
    options_save.wrapscan = &wrapscan
    options_save.ww = &ww
enddef

def OptionsSet() #{{{1
    # be silent when we execute substitutions, deletions, ...
    set report=99999
    # could be necessary for `norm! ...#...` later
    set wrapscan
    # necessary for `norm! ...l...` later
    set ww&vim
enddef

def OptionsRestore() #{{{1
    &report = options_save.report
    &wrapscan = options_save.wrapscan
    &ww = options_save.ww
    options_save = {}
enddef
# }}}1

Hitest()

