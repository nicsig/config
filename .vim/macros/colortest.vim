vim9script noclear

if exists('loaded') | finish | endif
var loaded = true

# Purpose:{{{
#
# If you're writing  a color scheme, you  may want to see  which combinations of
# colors (foreground + background) are the most readable/nice.
# This script should display the ones which are use the most often.
# For more info, see `:h 06.3`.
#}}}

# Usage: edit this  script if the combination of colors  you're interested in is
# not present, then do ":source %"

# Source: $VIMRUNTIME/syntax/colortest.vim



# black         black_on_white                          white_on_black
#                               black_on_black          black_on_black
# darkred       darkred_on_white                        white_on_darkred
#                               darkred_on_black        black_on_darkred
# darkgreen     darkgreen_on_white                      white_on_darkgreen
#                               darkgreen_on_black      black_on_darkgreen
# brown         brown_on_white                          white_on_brown
#                               brown_on_black          black_on_brown
# darkblue      darkblue_on_white                       white_on_darkblue
#                               darkblue_on_black       black_on_darkblue
# darkmagenta   darkmagenta_on_white                    white_on_darkmagenta
#                               darkmagenta_on_black    black_on_darkmagenta
# darkcyan      darkcyan_on_white                       white_on_darkcyan
#                               darkcyan_on_black       black_on_darkcyan
# lightgray     lightgray_on_white                      white_on_lightgray
#                               lightgray_on_black      black_on_lightgray
# darkgray      darkgray_on_white                       white_on_darkgray
#                               darkgray_on_black       black_on_darkgray
# red           red_on_white                            white_on_red
#                               red_on_black            black_on_red
# green         green_on_white                          white_on_green
#                               green_on_black          black_on_green
# yellow        yellow_on_white                         white_on_yellow
#                               yellow_on_black         black_on_yellow
# blue          blue_on_white                           white_on_blue
#                               blue_on_black           black_on_blue
# magenta       magenta_on_white                        white_on_magenta
#                               magenta_on_black        black_on_magenta
# cyan          cyan_on_white                           white_on_cyan
#                               cyan_on_black           black_on_cyan
# white         white_on_white                          white_on_white
#                               white_on_black          black_on_white
# grey          grey_on_white                           white_on_grey
#                               grey_on_black           black_on_grey
# lightred      lightred_on_white                       white_on_lightred
#                               lightred_on_black       black_on_lightred
# lightgreen    lightgreen_on_white                     white_on_lightgreen
#                               lightgreen_on_black     black_on_lightgreen
# lightyellow   lightyellow_on_white                    white_on_lightyellow
#                               lightyellow_on_black    black_on_lightyellow
# lightblue     lightblue_on_white                      white_on_lightblue
#                               lightblue_on_black      black_on_lightblue
# lightmagenta  lightmagenta_on_white                   white_on_lightmagenta
#                               lightmagenta_on_black   black_on_lightmagenta
# lightcyan     lightcyan_on_white                      white_on_lightcyan
#                               lightcyan_on_black      black_on_lightcyan

const SFILE: string = expand('<sfile>:p')
def Main()
    # Open this file in a window if it isn't edited yet.
    # Use the current window if it's empty.
    if expand('%:p') != SFILE
        var sfile: string = fnameescape(SFILE)
        if &mod || line('$') != 1 || getline(1) != ''
            exe 'new ' .. sfile
        else
            exe 'edit ' .. sfile
        endif
    endif

    syn clear
    cursor(1, 1)
    var lnum1: number = search('black_on_white', 'cW')
    var lnum2: number = search('lightcyan_on_black', 'cnW') + 1

    while search('_on_', 'W') < lnum2 + 2
        var col1: string = expand('<cword>')->substitute('\(\a\+\)_on_\a\+', '\1', '')
        var col2: string = expand('<cword>')->substitute('\a\+_on_\(\a\+\)', '\1', '')
        exe printf('hi col_%s_%s ctermfg=%s guifg=%s ctermbg=%s guibg=%s',
            col1, col2, col1, col1, col2, col2)
        exe printf('syn keyword col_%s_%s %s_on_%s',
            col1, col2, col1, col2)
    endwhile

    var isk_save: string = &l:isk
    try
        setl isk-=#
        var range: string = ':' .. lnum1 .. ',' .. lnum2
        exe range .. 'g/^# \a/Highlight()'
    finally
        &l:isk = isk_save
    endtry

    nohlsearch
enddef

def Highlight()
    var cword: string = expand('<cword>')
    exe printf('hi col_%s ctermfg=%s guifg=%s', cword, cword, cword)
    exe printf('syn keyword col_%s %s', cword, cword)
enddef

Main()

