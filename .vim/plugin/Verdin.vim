vim9script noclear

if exists('loaded') || stridx(&rtp, 'vim-Verdin') == -1
    finish
endif
var loaded = true

# Add parentheses after a completed function name.
# See `:h g:Verdin#autoparen`.
g:Verdin#autoparen = 2

# Don't try to guess what I meant; I meant what I wrote.
g:Verdin#fuzzymatch = 0

# Rationale:{{{
#
# Verdin is slow in our vimrc.
# You can reproduce by completing some command name, then save the Vim buffer.
# The saving will take one or two seconds.
#
# You can find which Verdin functions are the most responsible for this delay by
# executing:
#
#     :prof start /tmp/profile.log
#     :prof func *
#     :prof file *
#     :w
#     :prof pause
#     :noa qall!
#
# So, instead of using Verdin, we rely on the default omnicompletion inside our vimrc.
#
# ---
#
# According to `:h g:Verdin#setomnifunc`, we could also execute:
#
#     b:Verdin_setomnifunc = 0
#
# However, in practice, it doesn't work.
# The plugin doesn't even seem to inspect this variable.
#}}}
augroup NoVerdinInVimrc | au!
    au BufReadPost $MYVIMRC setl ofu=syntaxcomplete#Complete
augroup END

