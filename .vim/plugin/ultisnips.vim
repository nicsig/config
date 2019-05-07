if exists('g:loaded_ultisnips') || stridx(&rtp, 'ultisnips') == -1 || exists('g:no_plugin')
    finish
endif

" Why must I put the config of UltiSnips in this directory instead of `~/.vim/after/plugin/`?{{{
"
" If you configure UltiSnips from  `~/.vim/after/plugin/`, when the interface of
" UltiSnips  will be  sourced, it  won't see  you've chosen  a key  to expand  a
" snippet.
"
" So, it will use `Tab` and install some mappings.
" In `vim-completion`,  we also install some  mappings using the `Tab`  key, and
" the `<unique>` argument.
"
" They will conflict with the UltiSnips mappings.
"
" OTOH, if you  configure UltiSnips from this directory, when  UltiSnips will be
" sourced, it will see you've chosen a key to expand a snippet:
"
"         let g:UltiSnipsExpandTrigger = '<S-F15>'
"
" So, it will use it to install the mappings.
" And the key  we've chosen is purposefully NOT `Tab`,  so when `vim-completion`
" will be sourced, there'll be no conflict.
"}}}

" Why S-F15..17 ? {{{

" First, because  I'm looking  for unused  keys, which will  stay unused  in the
" future. Currently, the maximum value `xx` to create a <F-xx> {lhs} is `37`:
"
"         https://github.com/vim/vim/blob/8858498516108432453526f07783f14c9196e112/src/keymap.h#L194
"
" Beyond  this value,  creating a  mapping would  shadow the  `<` key,  probably
" because it's not interpreted as a function key anymore.
" We don't need to go as far as 37. On my current keyboard, the biggest function
" key is F12. So, we take our garbage keys from there.
"
" Second, if we assigned Tab / S-Tab, it would make the code more complex.
" Indeed, we would have to:
"
"     1. Capture the output of s:snr() in a global variable (g:snr_vimrc);
"        from our vimrc file.
"
"
"     2. Create the file ~/.vim/after/plugin/ultisnips.vim,
"        in which we would write:
"
"                ino  <silent> <tab>     <c-r>={g:snr_vimrc}expand_cycle_jump('N')<cr>
"                snor <silent> <tab>     <Esc>:call {g:snr_vimrc}expand_cycle_jump('N')<cr>

"                ino  <silent> <s-tab>   <c-r>={g:snr_vimrc}expand_cycle_jump('P')<cr>
"                snor <silent> <s-tab>   <Esc>:call {g:snr_vimrc}expand_cycle_jump('P')<cr>
"
"        Why? Because, by default Ultisnips would install these global mappings:
"
"                i  <tab>       * <c-r>=UltiSnips#ExpandSnippetOrJump()<cr>
"                s  <tab>       * <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>
"
"        Then during, the expansion of a snippet, it would temporarily install
"        these buffer-local mappings:
"
"                i  <s-tab>     *@<c-r>=UltiSnips#JumpBackwards()<cr>
"                s  <s-tab>     *@<Esc>:call UltiSnips#JumpBackwards()<cr>
"
"        They are removed after the expansion (:h UltiSnips-triggers):
"
"                UltiSnips will only map the jump triggers while a snippet is
"                active to interfere as little as possible with other mappings.
"
"        The first 2 mappings (Tab) call UltiSnips functions which expand a snippet
"        or jump to the next tabstop, but they can't cycle forward inside a menu, nor
"        can they complete text.
"        The last 2 mappings (S-Tab) call UltiSnips functions which jump to the
"        previous tabstop, but they can't cycle backward inside a menu.
"
"        So, we need a wrapper around ultisnips functions.
"
"
"     3. Add this file to the list of (2) files which one of our autocmd resources
"        automatically when we save our vimrc.
"        Why? Because when we save our vimrc, the 2 Tab mappings will be reset by
"        UltiSnips (only after the 1st save it seems ...).
"        Specifically because of this file:
"
"                ~/.vim/plugged/ultisnips/autoload/UltiSnips/map_keys.vim
"
"
"     4. Install the following autocmd:
"
"                augroup ultisnips_custom
"                    au!
"                    au! User UltiSnipsEnterFirstSnippet
"                    au User  UltiSnipsEnterFirstSnippet iunmap <buffer> <nowait> <s-tab>
"                augroup END
"
"      Why? Because during the expansion of a snippet, UltiSnips temporarily
"      installs this buffer-local mapping:
"
"                i  <s-tab>     *@<c-r>=UltiSnips#JumpBackwards()<cr>
"
"      This mapping overrides our own global mapping:
"
"                ino  <silent> <s-tab>   <c-r>={g:snr_vimrc}expand_cycle_jump('P')<cr>
"
"      Therefore, we would lose the capacity to cycle backward inside a menu.
"      It would be probably a good idea to also unmap the buffer-local mapping
"      for S-Tab in select mode (although I don't see an immediate pb with
"      UltiSnips overriding our mapping in this case, because there can't be
"      a menu in select mode, so we don't need to cycle back).
"
"}}}
let g:UltiSnipsExpandTrigger       = '<S-F15>'
let g:UltiSnipsJumpForwardTrigger  = '<S-F16>'
let g:UltiSnipsJumpBackwardTrigger = '<S-F17>'

" Purpose: gain the ability to manually end the expansion of a snippet
" Where did you find the code for the rhs of the mapping?{{{
"
" https://github.com/SirVer/ultisnips/issues/1017#issuecomment-452154595
"}}}
ino  <silent>  <c-g><s-tab>  <c-r>=execute(g:_uspy . ' UltiSnips_Manager._current_snippet_is_done()', 'silent!')[-1]<cr>
" TODO: Find a way to end the expansion of a snippet when we leave insert mode.{{{
"
" Hint: If you install a one-shot autocmd listening to InsertLeave,
" it will work, but you won't be able to jump to the 2nd tabstop of a snippet.
" It may be because our custom Tab mapping manually invokes `UltiSnips#ExpandSnippet()`.
"}}}

" Purpose:{{{
" We want  to be  able to press  Tab in  visual mode to  use the  {VISUAL} token
" inside ultisnips snippets.
"}}}
" Where does the {rhs} come from?{{{
"
" Give a valid key to `g:UltiSnipsExpandTrigger`, ex:
"
"       let g:UltiSnipsExpandTrigger = '<c-g>e'
"
" Then, restart Vim, and type:
"
"       verb xmap <c-g>e
"}}}
" Why do we need to install this mapping manually?{{{
"
" Because, we purposefully gave an invalid value to `g:UltiSnipsExpandTrigger`.
"}}}
xno  <silent>  <tab>  :call UltiSnips#SaveLastVisualSelection()<cr>gvs

" The  autotrigger feature  of UltiSnips  has a  *very* negative  impact on  the
" latency/jitter in Nvim.
" To make some tests, use typometer: https://github.com/pavelfatin/typometer
if has('nvim')
    augroup ultisnips_no_autotrigger
        au!
        au VimEnter * exe 'au! UltiSnips_AutoTrigger' | aug! UltiSnips_AutoTrigger
    augroup END
endif

" We need a way to enable UltiSnips's autotrigger on-demand.
nno <silent> cou :<c-u>call <sid>ultisnips_toggle_autotrigger()<cr>
fu! s:ultisnips_toggle_autotrigger() abort
    if exists('#UltiSnips_AutoTrigger')
        au! UltiSnips_AutoTrigger
        aug! UltiSnips_AutoTrigger
        echom '[UltiSnips AutoTrigger] OFF'
    else
        augroup UltiSnips_AutoTrigger
            au!
            au InsertCharPre,TextChangedI * call UltiSnips#TrackChange()
        augroup END
        echom '[UltiSnips AutoTrigger] ON'
    endif
endfu

" When we execute `:UltiSnipsEditSplit`, we want to open the snippet file in
" an horizontal split.
let g:UltiSnipsEditSplit = 'horizontal'

" We want UltiSnips to look for the snippet files in only 1 directory.{{{
"
"     ~/.vim/plugged/vim-snippets/UltiSnips/
"
" ... and  only there;  i.e. not  in a  public snippet  directory provided  by a
" third-party plugin:
"
"     https://github.com/honza/vim-snippets

" This has also the benefit of increasing the performance, because UltiSnips
" won't search the rtp.
"}}}
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/plugged/vim-snippets/UltiSnips']

" Prevent UltiSnips from looking for SnipMate snippets.{{{
"
" Those are in sub-directories of the rtp ending with `snippets/`.
"
" If we don't do this, UltiSnips will load SnipMate snippets that we install
" from a third party plugin, even though we've set `g:UltiSnipsSnippetDirectories`
" to a single absolute path.
"}}}
let g:UltiSnipsEnableSnipMate = 0

" Remove select mode mappings using printable characters {{{

" From :h mapmode-s :
"
"     Some commands work both in Visual and Select mode, some in only one.
"     Note that quite often "Visual" is mentioned where both Visual and Select
"     mode apply.
"     NOTE: Mapping a printable character in Select mode may confuse the user.
"     It's better to explicitly use :xmap, and :smap for printable characters.
"     Or use :sunmap after defining the mapping.
"
" It probably implies that mapping a printable character in select mode is a bad
" idea. For example, suppose that a plugin install this mapping:
"
"     :snor z abc
"
" When the user will hit `z` in select mode, he will expect the selected text
" to be replaced by the `z` character.
" But in fact, the selected text will be replaced with `abc`.
" This unexpected behavior can happen because some plugins use the `:v(nore)map`
" command instead of `:x(nore)map`.
"
" It could pose a pb for UltiSnips, when a tabstop is selected and we hit some
" character to replace the selection.
" Therefore, by default, each time we expand a tab trigger, UltiSnips removes
" all the select mode mappings whose {lhs} is a printable character.
"
" We like that (no printable character in a select mode mapping):
"}}}
let g:UltiSnipsRemoveSelectModeMappings = 1

" But don't do it for Tab!{{{
"
" Tab is NOT a printable character, but UltiSnips seems to unmap it as if it was one.
"}}}
let g:UltiSnipsMappingsToIgnore = ['mycompletion#snippet_or_complete']
" More info on this here:    :h UltiSnips-warning-smapping
" Edit:
" It doesn't seem necessary anymore, but I'll keep it anyway, just in case ...

