# Usage
## Default mappings

For customization, see `:h matchup-custom-mappings`.

### `%`

When on a recognized word, go forwards to its next matching word.
If at a close word, cycle back to the corresponding open word.
If the cursor is not on a word, seek forwards to one and then jump to its match.
This is an inclusive motion.

### `{count}%`

If `{count}` is less than `6`, go forwards `{count}` times.
Otherwise, go to `{count}` percentage in the file (`N%`).
See `:h g:matchup_motion_override_Npercent`.

This is useful for constructs with more than 2 words; example:

    if 1
      " do sth
    elseif 2
      " do sth else
    elseif 3
      " do sth else
    endif

Here, there  are 4 words (`if`,  `elseif`x2, `endif`); if your  cursor is before
`if`, and you want to jump to `endif`, you can press `3%`.

### `g%`

When on a recognized word, go backwards to `[count]`th previous matching word.
If at an open word, cycle around to the corresponding open word.
If the cursor is not on a word, seek forwards to one and then jump to its match.

### `[%`

Go to `[count]`th previous outer open word.
Allows navigation to the start of blocks surrounding the cursor.
This is  similar to  vim's built-in  `[(` and  `[{` and  is an  exclusive motion
(`:h matchup-feat-exclusive`).

### `]%`

Go to `[count]`th next outer close word.
Allows navigation to the end of blocks surrounding the cursor.
This is  similar to  vim's built-in  `])` and  `]}` and  is an  exclusive motion
(`:h matchup-feat-exclusive`).

### `z%`

Go to inside `[count]`th nearest block.
This is an exclusive motion when used with operators, except it eats whitespace.
For example, where `█` is the cursor position:

    █ call somefunction(      param1, param2)

`dz%` produces:

    param1, param2)

### `a%`

Select an any-block (`:h any-block`).
This closely matches vim's built-in `ab`.

### `{count}a%`

Select an open-to-close-block (`:h open-to-close-block`).
When  `{count}`  is  greater  than   `1`,  select  the  `{count}`th  surrounding
open-to-close block.

### `i%`

Select the inside of an `any-block`.
This closely matches vim's built-in `ib`.
See also `:h matchup-feat-linewise`.

### `{count}i%`

Select the inside of an `open-to-close-block`.
When  `{count}` is  greater  than  `1`, select  the  inside  of the  `{count}`th
surrounding open-to-close block.

### `{count}ds%`

Delete `{count}`th surrounding matching words.
This only works for open and close words.
Requires `g:matchup_surround_enabled` = 1.

### `{count}cs%`

Change `{count}`th surrounding matching words.
This only works for open and close words.
If  vim-surround is  installed,  you  can type  replacements  according to  that
plugin's rules.
Otherwise, match-up will give you the opportunity to type a single character.
Some simple replacement pairs are supported.
Requires `g:matchup_surround_enabled` = 1.

##
## Customizing mappings

`match-up` provides a number of default mappings.
Each right-hand side is provided as a `<plug>`-mapping.
For any  given map,  the default  mapping will only  be created  if it  does not
already exist.
This means that if a user defines a custom mapping, e.g., with:

    nmap <leader>% <plug>(matchup-z%)

the corresponding default lhs will not be mapped.

    ┌────────┬─────────────────────────────┬──────┬────────────┐
    │ LHS    │ RHS                         │ Mode │ Module     │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ %      │ <plug>(matchup-%)           │ nxo  │ motion     │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ g%     │ <plug>(matchup-g%)          │ nxo  │ motion     │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ [%     │ <plug>(matchup-[%)          │ nxo  │ motion     │
    │ ]%     │ <plug>(matchup-]%)          │ nxo  │ motion     │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ z%     │ <plug>(matchup-z%)          │ nxo  │ motion     │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ a%     │ <plug>(matchup-%)           │ x o  │ text_obj   │
    │ i%     │ <plug>(matchup-%)           │ x o  │ text_obj   │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ ds%    │ <plug>(matchup-ds%)         │ n    │ surround   │
    │ cs%    │ <plug>(matchup-cs%)         │ n    │ surround   │
    ├────────┼─────────────────────────────┼──────┼────────────┤
    │ (none) │ <plug>(matchup-hi-surround) │ n    │ matchparen │
    └────────┴─────────────────────────────┴──────┴────────────┘

## open, close, mid

What do we mean by open, close, mid?
This depends  on the specific file  type and is configured  through the variable
`b:match_words`; here are a couple of examples:

    if x == 1
      call one()
    elseif x == 2
      call two()
    else
      call three()
    endif

## any-block, open-to-close-block

For  the  vim-script language,  match-up  understands  the words  `if`,  `else`,
`elseif`, `endif` and that they form a sequential construct.
The "open" word  is `if`, the "close"  word is `endif`, and the  "mid" words are
`else` and `elseif`.
The `if`/`endif`  pair is called  an "open-to-close" block and  the `if`/`else`,
`else`/`elsif`, and `elseif`/`endif` are called "any" blocks.

---

Another example in `C`, `C++`:

    #if 0
    #else
    #endif

    void some_func() {
        if (true) {
          one();
        } else if (false && false) {
          two();
        } else {
          three();
        }
    }

Since in C and C++, blocks are delimited using braces (`{` & `}`), match-up will
recognize `{` as the open word and `}` as the close word.
It will ignore  the `if` and `else if`  because they are not defined  in vim's C
file type plugin.

On  the  other  hand,  match-up  will recognize  the  `#if`,  `#else`,  `#endif`
preprocessor directives.

See `:h matchup-feat-exclusive` and `:h matchup-feat-linewise` for some examples
and important special cases.

## Highlighting matches

To disable match highlighting at startup, use:

    let g:matchup_matchparen_enabled = 0

in your vimrc.
See `:h matchup-opts-matchparen` for more information and related options.

You can enable highlighting on the fly using:

    :DoMatchParen

Likewise, you can disable highlighting at any time using:

    :NoMatchParen

After start-up, is  better to use `:NoMatchParen` and  `:DoMatchParen` to toggle
highlighting globally than setting the global variable since these commands make
sure not to leave stale matches around.

## Highlight surrounding

To highlight the  surrounding delimiters until the cursor moves,  use a map such
as the following:

    nmap <silent> <F7> <plug>(matchup-hi-surround)

There is no default map for this feature.

##
## Inclusive and exclusive motions

In vim,  character motions following operators  (such as `d` for  delete and `c`
for change) are either inclusive or exclusive.
This means they either include the ending position or not.
Here, "ending  position" means  the line and  column closest to  the end  of the
buffer of the region swept over by the motion.
match-up is designed  so that `d]%` inside a set  of parenthesis behaves exactly
like `d])`, except generalized to words.

Put differently, forward exclusive motions will not include the close word.
In this example, where `█` is the cursor position:

    if █x | continue | endif

pressing `d]%` will produce (cursor on the `e`):

    if endif

To include the close word, use either `dv]%` or `vd]%`.
This is also compatible with vim's `dv])` and `dv]}`.

Operators over backward exclusive motions  will instead exclude the position the
cursor was on before the operator was invoked; for example, in:

    if █x | continue | endif

pressing `d[%` will produce:

    █x | continue | endif

This is compatible with vim's `d[(` and `d[{`.

### `d%`, `dg%`

Unlike `]%`, `%` is an inclusive motion.
As a  special case for  the `d` (delete) operator,  if `d%` leaves  behind lines
whitespace, they will be deleted also.
In effect, it will be operating linewise.
As an example, pressing `d%` will leave behind nothing.

    █(

    )

To operate character-wise in this situation, use `dv%` or `vd%`.
This is vim compatible with the built-in `d%` on items in `'matchpairs'`.

##
## Linewise operator/text-object combinations

Normally, the text objects `i%>` and `a%` work character-wise.
However, there are some special cases.
For certain  operators combined  with `i%`,  under certain  conditions, match-up
will effectively operate linewise instead.
For example, in:

    if condition
     █call one()
      call two()
    endif

pressing `di%` will produce:

    if condition
    endif

even though deleting ` condition` would be suggested by the object `i%`.
The intention is to make operators more useful in some cases.
The following rules apply:

   1. The operator must be listed in `g:matchup_text_obj_linewise_operators`.
      By default this is `d` and `y` (e.g., `di%` and `ya%`).

   2. The outer block must span multiple lines.

   3. The open and close delimiters must be more than one character long.  In
      particular, `di%` involving a `(`...`)` block will not be subject to
      these special rules.

To prevent this behavior for a particular operation, use `vi%d`.
Note that special cases involving indentation still apply (like with `i)` etc).

To disable this entirely, remove the operator from the following variable:

    let g:matchup_text_obj_linewise_operators = [ 'y' ]

Note: unlike  vim's built-in `i)`,  `ab`, etc., `i%`  does not make  an existing
visual mode character-wise.

A second special case involves `da%`.
In this example:

    if condition
     █call one()
      call two()
    endif

pressing `da%` will delete all four lines and leave no whitespace.
This is compatible with vim's `da(`, `dab`, etc.

##
## Commands
### `:NoMatchParen`

Disable matching after the plugin was loaded.

### `:DoMatchParen`

Enable matching again.

### `:MatchupShowTimes`

Display performance data, useful for debugging slow matching.
Shows last, average, and maximum times.

### `:MatchupClearTimes`

Reset performance counters to zero.

### `:MatchupWhereAmI`

Echos your  position in code  by finding  successive matching words,  like doing
`[%` repeatedly; for example:

    1310 do_pending_operator( … { ⯈ if ((finish_op || VIsual_active) && oap- … {~

Appending a question  mark makes the output more verbose  about your position in
code by displaying several lines; for example:

    :MatchupWhereAmI?
    1310 do_pending_operator(cmdarg_T *cap, int old_col, int gui_yank) … {~
    1349     if ((finish_op || VIsual_active) && oap->op_type != OP_NOP) … {~

### `:MatchupReload`

Reload the plugin, mostly for debugging.
Note that this does not reload `'matchpairs'` or `b:match_word`.

##
## Options
### `g:matchup_*_enabled`

    ┌──────────────────────────────┬────────────────────────────────┐
    │ g:matchup_mappings_enabled   │ all mappings                   │
    ├──────────────────────────────┼────────────────────────────────┤
    │ g:matchup_matchparen_enabled │ match highlighting             │
    ├──────────────────────────────┼────────────────────────────────┤
    │ g:matchup_mouse_enabled      │ double click to select matches │
    ├──────────────────────────────┼────────────────────────────────┤
    │ g:matchup_motion_enabled     │ `matchup-%`, `%`, `[%`, `]%`   │
    ├──────────────────────────────┼────────────────────────────────┤
    │ g:matchup_text_obj_enabled   │ `a%`, `i%`                     │
    └──────────────────────────────┴────────────────────────────────┘

Set to 0 to disable a particular module or feature.

Defaults: 1

### `g:matchup_delim_stopline`

Configures the number of lines to search in either direction while using motions
and text objects; does not apply to match highlighting.
See `:h g:matchup_matchparen_stopline` instead.

Default: 1500

### `g:matchup_delim_noskips`

This option controls whether matching is done within strings and comments.
By default, it is set to 0 which means all valid matches are made within strings
and comments.
If set to  1, symbols like `()` will  still be matched but words  like `for` and
`end`  will not;  if  set to  2,  nothing  will be  matched  within strings  and
comments.

    let g:matchup_delim_noskips = 1
    let g:matchup_delim_noskips = 2

Default: 0 (matching enabled within strings and comments)

### `g:matchup_delim_start_plaintext`

When enabled (the default), the plugin will be loaded for all buffers, including
ones without a file type set.
This allows matching to  be done in new buffers and plain text  files but adds a
small start-up cost to vim.

Default: 1

Note that this variable has priority over `g:matchup_*_enabled`.
So, for example, if you have:

    let g:matchup_matchparen_enabled = 1
    let g:matchup_delim_start_plaintext = 0

And you open  a plain text file, matching parentheses  won't be highlighted, and
`%` won't let you jump from a parenthesis to the other matching one.

##
## Variables

   - b:match_words
   - b:match_skip
   - b:match_ignorecase

match-up understands these variables originally from matchit.
These are set in the respective ftplugin files.
They may not exist for every file type.
To support a new file  type, create a file `after/ftplugin/{filetype}.vim` which
sets them appropriately.

##
## Module matchparen

To disable the module, use this in your vimrc:

    let g:matchup_matchparen_enabled = 0

Note: vim's built-in plugin `pi_paren` plugin is also disabled.
The variable `g:loaded_matchparen` has no effect on match-up.

Default: 1

You can  also enable  and disable  highlighting for  specific buffers  using the
variable `:h b:matchup_matchparen_enabled`.

### Customizing the highlighting colors

match-up  uses the  `MatchParen` highlighting  group  by default,  which can  be
configured; for example:

    :hi MatchParen ctermbg=blue guibg=lightblue cterm=italic gui=italic

You may want to put this inside a `ColorScheme` autocmd so it is preserved after
colorscheme changes:

    augroup matchup_matchparen_highlight
        autocmd!
        autocmd ColorScheme * hi MatchParen guifg=red
    augroup END

You can also highlight words  differently than parentheses using the `MatchWord`
highlighting group.
You  might do  this if  you find  the `MatchParen`  style distracting  for large
blocks.
>
    :hi MatchWord ctermfg=red guifg=blue cterm=underline gui=underline

There are also  `MatchParenCur` and `MatchWordCur` which allow  you to configure
the highlight separately for the match under the cursor.

    :hi MatchParenCur cterm=underline gui=underline
    :hi MatchWordCur cterm=underline gui=underline

###
### `b:matchup_matchparen_enabled`

Set to 0 to disable highlighting on  a per-buffer basis (there is no command for
this).
By default,  when disabling highlighting  for a particular buffer,  the standard
plugin `pi_paren` will still be used for that buffer.

Default: undefined (equivalent to 1)

### `b:matchup_matchparen_fallback`

If highlighting is  disabled on a particular buffer, match-up  will fall back to
the vim standard plugin `pi_paren`,  which will highlight `'matchpairs'` such as
`()`, `[]`, & `{}`.
To disable this, set this option to 0.

Default: undefined (equivalent to 1)

A  common usage  of these  options is  to automatically  disable matchparen  for
particular file types:

    augroup matchup_matchparen_disable_ft
        autocmd!
        autocmd FileType tex let [b:matchup_matchparen_fallback,
            \ b:matchup_matchparen_enabled] = [0, 0]
    augroup END

### `g:matchup_matchparen_singleton`

Whether or not to highlight recognized words even if there is no match.

Default: 0

###
### `g:matchup_matchparen_stopline`

The number of lines to search in either direction while highlighting matches.
Set this conservatively since high values may cause performance issues.

Default: 400

### `g:matchup_matchparen_timeout`, `g:matchup_matchparen_insert_timeout`

Adjust the timeouts in milliseconds for highlighting.

Defaults: `g:matchparen_timeout`, `g:matchparen_insert_timeout`
(300, 60 respectively)

`b:matchup_matchparen_timeout`  and   `b:matchup_matchparen_insert_timeout`  are
buffer local versions of the above.

### `g:matchup_matchparen_deferred`

Deferred highlighting  improves cursor  movement performance (for  example, when
using `hjkl`) by  delaying highlighting for a  short time and waiting  to see if
the cursor continues moving.

Default: 0 (disabled)

### `g:matchup_matchparen_deferred_show_delay`

Delay, in milliseconds, between when the cursor moves and when we start checking
if the cursor is on a match.
Applies to both making highlights and clearing them for deferred highlighting.

Note: these delays cannot be changed dynamically and should be configured before
the plugin loads (e.g., in your vimrc).

Default: 50

### `g:matchup_matchparen_deferred_hide_delay`

If the cursor has not stopped moving,  assume highlight is stale after this many
milliseconds; stale highlights are hidden.

Note: this option cannot be changed dynamically.

Default: 700

### `g:matchup_matchparen_deferred_fade_time`

When  set to  `{time}` in  milliseconds, the  deferred highlighting  behavior is
changed in two ways:

   1. Highlighting of matches is preserved for at least `{time}` even when the
      cursor is moved away.

   2. If the cursor stays on the same match for longer than `{time}`,
      highlighting is cleared.

The  effect  is  that  highlighting  occurs  momentarily  and  then  disappears,
regardless of where the cursor is.
It is  possible that  fading takes longer  than `{time}`, if  vim is  busy doing
other things.

This value should be greater than the deferred show delay.
Note: this option cannot be changed dynamically.

Example:

    let g:matchup_matchparen_deferred = 1
    let g:matchup_matchparen_deferred_fade_time = 450

Default: 0 (fading disabled)

### `g:matchup_matchparen_pumvisible`

If set to 1, matches will be made even when the `popupmenu-completion` is
visible.  If you use an auto-complete plugin which interacts badly with
matching, set this option to 0.

Default: 1

### `g:matchup_matchparen_nomode`

When not  empty, match  highlighting will  be disabled  in the  specified modes,
where each mode is a single character like in the `mode()` function.
E.g., to disable highlighting in insert mode,

    let g:matchup_matchparen_nomode = 'i'

and in visual modes,

    let g:matchup_matchparen_nomode = "vV\<c-v>"

Note: In visual modes, this takes effect only after moving the cursor.

Default: ''

### `g:matchup_matchparen_hi_surround_always`

Always highlight the surrounding words, if possible.
This is like  `<plug>(matchup-hi-surround)` but is updated each  time the cursor
moves.
This requires deferred matching (`g:matchup_matchparen_deferred` = 1).

Default: 0

### `g:matchup_matchparen_hi_background`

Highlight buffer background between matches.
This  uses   the  `MatchBackground`   highlighting  group   and  is   linked  to
`ColorColumn` by default but can be configured with:

    :hi MatchBackground guibg=grey ctermbg=grey

Default: 0

##
## Module motion
### `g:matchup_motion_override_Npercent`

In vim, `{count}%` goes  to the `{count}` percentage in the  file (see `:h N%`).
match-up overrides  this motion for  small `{count}` (by default,  anything less
than 7); for example, to allow `{count}%` for `{count}` up to 11:

    let g:matchup_motion_override_Npercent = 11

To disable this feature, and restore vim's default `{count}%`:

    let g:matchup_motion_override_Npercent = 0

### `g:matchup_motion_cursor_end`

If enabled,  cursor will land  on the  end of mid  and close words  while moving
downwards (`%`/`]%`).
While moving upwards (`g%`, `[%`) the cursor will land on the beginning.
Set to 0 to disable.
Note: this has no effect on operators:  `d%` will delete inclusive of the ending
word (this is compatible with matchit).

      Default: 1

### `g:matchup_delim_count_fail`

When disabled  (default), giving an invalid  count to the `[%`  and `]%` motions
and the text objects `i%` and `a%` will cause the motion or operation to fail.
When enabled, they will move as far as possible.
Note: targeting high counts when this  option is enabled can become slow because
many positions need to be tried before giving up.

Default: 0

##
## Module `text_obj`
### `g:matchup_text_obj_linewise_operators`

Modifies the set of operators which may operate linewise with `i%`.
See `:h matchup-feat-linewise`.

You may use `'v'`, `'V'`, and `"\<c-v>"` to the specify the corresponding visual mode.

You  can also  specify  custom plugin  operators with  `g@`  and optionally,  an
expression separated by a comma.
For example, to make `commentary`'s `gc`  mapping work likewise when used in the
operator `gci%`:

    fu IsCommentaryOpFunc()
      return &operatorfunc ==? matchstr(maparg('<Plug>Commentary', 'n'),
          \ '\c<SNR>\w\+\ze()\|set op\%(erator\)\?func=\zs.\{-\}\ze<cr>')
    endfu

    let g:matchup_text_obj_linewise_operators = ['d', 'y', 'g@,IsCommentaryOpFunc()']

Default: `['d', 'y']`

##
## Module surround
### `g:matchup_surround_enabled`

Enables the surround module which provides maps `ds%` and `cs%`.

Default: 0

##
## File type options
### LaTeX

By  default, match-up  is disabled  for tex  files when  the plugin  `vimtex` is
detected.
To enable match-up for tex files, use the following in your vimrc:

    let g:matchup_override_vimtex = 1

This will replace vimtex's built-in highlighting and `%` map.

Note: matching may be computationally intensive for complex LaTeX documents.
If you experience slowdowns, consider using the following option:

    let g:matchup_matchparen_deferred = 1

###
### HTML
#### `g:matchup_matchpref.html.nolists`

When set  to 1, this option  disables matching and navigation  between groups of
list items in HTML documents such as the following:

    <ul>
      <li>One</li>
      <li>Two</li>
    </ul>

By default, `%` will navigate from `<ul>` to `<li>` to `<li>` to `</ul>`.

Default: 0

#### `g:matchup_matchpref.html.tagnameonly`

When set to 1,  only the tag name will be highlighted, not  the rest of the tag,
e.g., the "a" in:

    <a href="http://example.com">Link</a>

This works for xml, html, and some other html-based types.

Default: 0

###
### Match preferences

A limited number  of common preferences are available which  affect how matching
is done for a particular filetype.
They may be set through the `matchup_matchpref` dictionary:

    let g:matchup_matchpref[&filetype].option_name = 1

###
### Customization
#### `g:matchup_hotfix[&filetype]`

For each  file type, this  option can be  set to the  string name of  a function
which will be  called when loading files, prior to  checking `b:match_words` and
`b:match_skip`.
This option can be used to quickly customize matching for particular file types:

    function! VimHotfix()
      " customization
    endfunction
    let g:matchup_hotfix['vim'] = 'VimHotfix'

##### `b:matchup_hotfix`

This is an alternative buffer-local name for adding customization.

####
#### `matchup#util#patch_match_words`

    call matchup#util#patch_match_words(before, after)

This function replaces the literal  string `before` contained in `b:match_words`
with the literal string `after`.
When placed in  an autocommand or in  the file `after/ftplugin/{&filetype}.vim`,
it can  be used to customize  the matching regular expressions  for a particular
file type.

#### `matchup#util#append_match_words`

    call matchup#util#append_match_words(str)

Adds a set of patterns to `b:match_words`, adding a comma if necessary.

##
# Issues
## Highlighting is not correct for construct X!

match-up  uses  matchit's filetype-specific  data,  which  may not  give  enough
information to create proper highlights.
To fix this, you may need to modify `b:match_words`.

## I'm having performance problems!

match-up aims to be as fast as  possible, but highlighting matching words can be
intensive and may be slow on less powerful machines.
There are a few things you can try to improve performance:

  - Update to a recent version of vim.  Newer versions are faster, more
    extensively tested, and better supported by match-up.

  - Try deferred highlighting, which delays highlighting until the cursor is
    stationary to improve cursor movement performance.
    `g:matchup_matchparen_deferred`

  - Lower the highlighting timeouts.  If highlighting takes longer than the
    timeout, highlighting will not be attempted again until the cursor moves.
    `g:matchup_matchparen_timeout`, `g:matchup_matchparen_insert_timeout`

If are having any  other performance issues, please open a  new issue and report
the output of `:MatchupShowTimes`.

## Matching does not work when lines are too far apart!

The number of search lines is limited for performance reasons.
You may increase the limits with the following options:

    let g:matchup_delim_stopline      = 1500 " generally
    let g:matchup_matchparen_stopline = 400  " for match highlighting only

## The maps `1i%` and `1a%` are difficult to press!

You may use the following maps `I%` and `A%` for convenience:

    function! s:matchup_convenience_maps()
      xnoremap <sid>(std-I) I
      xnoremap <sid>(std-A) A
      xmap <expr> I mode()=='<c-v>'?'<sid>(std-I)':(v:count?'':'1').'i'
      xmap <expr> A mode()=='<c-v>'?'<sid>(std-A)':(v:count?'':'1').'a'
      for l:v in ['', 'v', 'V', '<c-v>']
        execute 'omap <expr>' l:v.'I%' "(v:count?'':'1').'".l:v."i%'"
        execute 'omap <expr>' l:v.'A%' "(v:count?'':'1').'".l:v."a%'"
      endfor
    endfunction
    call s:matchup_convenience_maps()

Note: this is not compatible with the plugin targets.vim.

##
# Interoperability
## vimtex, for LaTeX documents

By default, match-up will be disabled automatically for tex files when vimtex
is detected.  To enable match-up for tex files, use:

    let g:matchup_override_vimtex = 1

match-up's matching  engine is more  advanced than vimtex's and  supports middle
delimiters such as `\middle|` and `\else`.
The exact set of delimiters recognized may differ between the two plugins.
For example, the mappings `da%` and `dad` will not always match, particularly if
you have customized vimtex's delimiters.

## Matchit

matchit.vim should not be loaded.
If it  is loaded, it  must be loaded after  match-up (in this  case, matchit.vim
will be disabled).
Note that  some plugins, such  as vim-sensible,  load matchit.vim so  these must
also be initialized after match-up.

## Matchparen emulation

match-up loads `matchparen` if it is not already loaded.
Ordinarily,  match-up  disables matchparen's  highlighting  and  emulates it  to
highlight  the symbol  contained in  the 'matchpairs'  option (by  default `()`,
`[]`, and `{}`).
If  match-up   is  disabled  per-buffer   using  `b:matchup_matchparen_enabled`,
match-up will use matchparen instead of its own highlighting.
See `:h b:matchup_matchparen_fallback` for more information.

## Other plugins

match-up does not currently provide support for auto-completion.
The following plugins may be useful for this:

   - `vim-endwise`         https://github.com/tpope/vim-endwise
   - `auto-pairs`          https://github.com/jiangmiao/auto-pairs
   - `delimitMate`         https://github.com/Raimondi/delimitMate
   - `splitjoin.vim`       https://github.com/AndrewRadev/splitjoin.vim

There  is basic  support for  deleting and  changing surroundings,  but you  may
prefer to use one of the following:

   - `vim-surround`        https://github.com/tpope/vim-surround
   - `vim-sandwich`        https://github.com/machakann/vim-sandwich

##
# Todo
## Sometimes, words are highlighted inside comments; they should not.

Write this in `/tmp/vim.vim`:

    " foo if bar
    " baz end qux

And position your cursor on `if`: `if` and `end` are highlighted.
They should not.
match-up understands `b:match_skip`, try to set it to fix this issue.

See: <https://github.com/andymass/vim-matchup/issues/54>
And read the documentation about `vim-matchit`:

    :packadd matchit | h matchit

## In `augroup foo`, the `f` is wrongly highlighted.

The   issue   seems   to   come   from   our   `b:match_words`   assignment   in
`~/.vim/plugged/vim-vim/after/ftplugin/vim.vim`.

In particular, it contains these patterns:

                                  vv
    \<aug\%[roup]\s\+\%(END\>\)\@!\S
    \<aug\%[roup]\s\+END\>

I copied them from `$VIMRUNTIME/ftplugin/vim.vim`.

If you remove the assignment, the issue is fixed.
I think that's because match-up, by default, replaces this pattern:

    \<aug\%[roup]\s\+\%(END\>\)\@!\S

With this one:

    \<aug\%[roup]\ze\s\+\%(END\>\)\@!\S

Notice the introduction of `\ze` (see `~/.vim/plugged/vim-matchup/after/ftplugin/vim_matchup.vim`).
Our assignment probably overwrites this fix.
So, I think we need to edit or remove this `b:match_words` assignment.
Remember that we need to include these patterns:

    {\@1<!{{\@!:}\@1<!}}\@!

And we  may need to  edit the  patterns for `:function`/`:endfunction`  (see the
comment at the top).

Try   to  use   the  `..=`   operator  to   append  your   change,  and/or   use
`matchup#util#patch_match_words()`.

## Tweak `cop` so that the toggling is local to the current buffer.

To do so, you could set `b:matchup_matchparen_enabled` to `0` in all the buffers
except the current one.

Update: Is it a good idea? What about just toggling a global state?

##
## Errors in help page (submit PR)

    g%                      When on a recognized word, go backwards to [count]th
    previous matching word.  If at an open word, cycle
    around to the corresponding **open** word.  If the cursor
    is not on a word, seek forwards to one and then jump
    to its match.

Replace the last `open` with `close`.

---

    Match preferences~                                        *g:matchup_matchpref*

Break down the line in two:

                                                              *g:matchup_matchpref*
    Match preferences~

