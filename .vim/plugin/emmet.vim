vim9script noclear

if exists('loaded') || stridx(&rtp, 'emmet-vim') == -1
    finish
endif
var loaded = true

# Options {{{1

# We don't want global mappings.  We prefer buffer-local ones.
g:user_emmet_install_global = 0

# We only need mappings in insert and visual mode (not normal).
g:user_emmet_mode = 'iv'

# We use `C-g` as a prefix key instead of `C-y`.
g:user_emmet_leader_key = '<c-g>'

# https://github.com/mattn/emmet-vim/issues/378#issuecomment-329839244
#
# Issue1: Sometimes it's annoying:{{{
#
#    - write a url and press `C-g a`
#    - expand this abbreviation:    #page>div.logo+ul#navigation>li*5>a{Item $}
#}}}
# Issue2: It can break `C-g N` (jump to previous point).{{{
# The issue is in this function:
#
#     emmet#lang#html#moveNextPrev()
#
# From this file:
#     $HOME/.vim/plugged/emmet-vim/autoload/emmet/lang/html.vim:887
#
# The pattern is right, but sometimes, it needs to be searched twice
# instead of once.
#}}}
g:user_emmet_settings = {
        html: {
            block_all_childless: 1,
        },
    }

# For more options see:
#
#     ~/.vim/plugged/emmet-vim/autoload/emmet.vim:999
#
# The keys of the first level are names of filetypes.
# The keys of the second level are names of abbreviations, snippets and options.

# Autocmds {{{1

augroup MyEmmet | au!
    au FileType css,html plugin#emmet#installMappings()
    # enable emmet mappings in our notes about web-related technologies (html, css, emmet, ...){{{
    #
    # TODO:
    # However, maybe we could enable them to all markdown files...
    #
    #     au FileType css,html,markdown plugin#emmet#installMappings()
    #                          ^------^
    #}}}
    au BufReadPost,BufNewFile */wiki/web/*.md plugin#emmet#installMappings()
augroup END

