Read these PRs:

    pre/post-expand and post-jump actions

            https://github.com/SirVer/ultisnips/pull/507

    Autotrigger

            https://github.com/SirVer/ultisnips/pull/539

And this issue:

    Markdown table snippet breaks on various dimensions

            https://github.com/SirVer/ultisnips/issues/877



Watch all gifs from `vim-pythonx` and `vim-snippets`.
Re-read all your snippets (fix/improve).
Re-read this file.
Understand 3 advanced examples:

        https://github.com/SirVer/ultisnips/tree/master/doc/examples/autojump-if-empty
        https://github.com/SirVer/ultisnips/tree/master/doc/examples/snippets-aliasing
        https://github.com/SirVer/ultisnips/tree/master/doc/examples/tabstop-generation

Move our notes about ultisnips in cheat/ here.
Read documentation.


The following events:

    UltiSnipsEnterFirstSnippet
    UltiSnipsExitLastSnippet

… are NOT fired when the snippet  is automatically expanded (like with `fu` in
a vim file). At least, it seems so.
Make some tests. Document the results.
It may be a bug. Report it.

# Misc

When  you  write some  python  code  (function/interpolation),  you can  add  an
arbitrary key  to `snip`, but it  will be removed as  soon as the code  has been
processed.

OTOH, `snip` persists during the whole  expansion of a snippet.
Some of its keys are also persistent: `context` is one of them.
So, if you assign some data to the `context` key of `snip`, in some python code,
it will be accessible to the next one.

You can use this to pass arbitrary information from a statement to another.

Finally, if you create a new variable:

        • in a python function, it will be local to the function:

            NOT accessible to the next processed function

        • in a python interpolation, it will be local to the snippet:

            ACCESSIBLE to the next interpolation

---

The way to refer to the last visually selected text is inconsistent:

    snip.visual_text       (context)
    snip.visual_content    (pre_expand)
    snip.v.text            (interpolation)
    │    │ │
    │    │ └ attribute
    │    └ property
    └ object

Same thing for the last visual mode:

    snip.visual_mode    (context)
    snip.v.mode         (interpolation)

---

Don't confuse the method `re.match()` with the object `match`.

`re.match()` allows you to compare a string with a regex.
`match` is automatically created by UltiSnips when you use the `r` option to
create a snippet whose tab_trigger is a regex.

It contains the match and all captured groups resulting from the comparison
between the regex of the tab_trigger and the text which was in front of the
cursor when Tab was pressed.

---

To retrieve a capturing group, use the `group()` method:

        match.group(123)
        snip.context.group(123)

                123th  captured group,  in the  regex matched  against the  text
                before the cursor; the regex being used in:

                • the tab_trigger       (with the `r` option)
                • the expression field  (with the `e` option)

---

What's the difference between:

        $0
          ${VISUAL}
        $0${VISUAL}
       ${0:${VISUAL}}

`${VISUAL}` is only a PLACEHOLDER automatically  replaced by the contents of the
last  visual selection. It  is NOT  a tabstop:  by default,  UltiSnips does  not
select it, and therefore does not position the cursor somewhere near it.

OTOH, `$0` is a TABSTOP. And as all tabstops, it can have a placeholder.  We can
use this  property to select  the contents of `${VISUAL}`  by writing it  as the
placeholder of `$0`. Or any other tabstop.

---

NEVER use a use Vim command to modify the buffer. UltiSnips would not be able
to track changes in buffer from actions. It would raise an error.
Instead, modify a line of the buffer via `snip.buffer`.

---

You can't use a line continuation in a VimL interpolation.

---

Inside a snippet, you can invoke a python function in 2 ways:

    • as a simple routine:                          `!p           func()`
    • for its output to be inserted in the buffer:  `!p snip.rv = func()`

---

There's no need to invoke a Vim function with `vim.command()`.
Use `vim.eval()` instead. It's less verbose:

        vim.command('call Func()')
        vim.eval('Func()')

`vim.command()` should be reserved to Ex commands (!= `:call`):

        vim.command('12,34delete')

---

The python modules:

    • os
    • random
    • re
    • string
    • vim

… are pre-imported within the scope of the snippet code.  Other modules can be
imported using the python 'import' command:

    `!p
    import uuid
    …
    `

# Predefined Variables / Methods

Besides  an in-snippet  interpolation, there  are 4  other statements  which can
invoke python code:

        • context
        • pre_expand
        • post_expand
        • post_jump

## Universal

    snip.buffer    (alias for `vim.current.window.buffer`)

            Lines of current buffer.
            Allows to modify the buffer.

            When used from `pre_expand`:

            Snippet expansion position will be automatically adjusted.
            IOW, don't worry about your cursor being on the wrong line because
            you added some text before the snippet.


    snip.window    (interpolation ✘)    (alias for `vim.current.window`)

          FIXME:
          What's its purpose?


    snip.snippet_start
    snip.snippet_end

            ┌───────────────┬───┐
            │ context       │ ✘ │
            ├───────────────┼───┤
            │ pre_expand    │ ✘ │
            ├───────────────┼───┤
            │ interpolation │ ✘ │
            ├───────────────┼───┤
            │ post_expand   │ ✔ │
            ├───────────────┼───┤
            │ post_jump     │ ✔ │
            └───────────────┴───┘

            Warning:

            You can  use them  from an  interpolation, but  they don't  give the
            expected result: they seem to give the position of the tab_trigger.


    snip.line      (interpolation ✘)
    snip.column    (")
    snip.cursor    (")

            Position of the cursor.
            All 3 variables are 0-indexed.

            `snip.cursor`  behaves  like   `vim.current.window.cursor`  but  the
            coordinates  are  indexed  from  zero, and  the  object  comes  with
            additional methods:

                    • preserve()        - special method for executing pre/post/jump actions

                    • set(line,column)  - sets cursor to specified line and column

                    • to_vim_cursor()
                                        - returns cursor position, but the coordinates being
                                          indexed from 1;
                                          suitable to be assigned to `vim.current.window.cursor`

                    It seems to be useful, for example, when you capture the position of the cursor
                    in a function with `snip.cursor`, then you want to restore it in another function
                    via `vim.current.window.cursor`:

                    https://github.com/reconquest/snippets/blob/b5d86da79604e7d341d26de1f3366b3f1373f7c5/python.snippets#L49

                    Btw, I don't know how he can pass an argument to `snip.cursor.to_vim_cursor()`.
                    On my machine, it raises an error. The function doesn't accept any argument.


                                               NOTE:

            None of the variables / methods exist in an interpolation.
            However, you can still use `vim.current.window.cursor` instead of `snip.cursor`.


                                               NOTE:

            Although, you  can call  `snip.cursor.set(x,y)` from  all statements
            (but not in an interpolation), it has an effect only from `pre_expand`
            and `post_jump`.


    snip.context

            Result of context condition.
            You can (ab)use this property to pass an arbitrary information from
            a statement to another:

                    https://github.com/reconquest/snippets/blob/b5d86da79604e7d341d26de1f3366b3f1373f7c5/python.snippets#L33-L38

            Here, the author passes an information from `pre_expand` to `post_jump`.
            They use `pre_expand` to “enrich” `snip.context`.
            To do so, they move it inside a dictionary:

                    • one of its value is the original `snip.context`
                    • one is `snip.cursor`
                    • one is `snip.visual_content`
                    • one is an arbitrary info stored

            They then use `post_jump` to analyze this enriched `snip.context`.


    snip.expand_anon(my_snippet)    (not in an interpolation)

            Allows to expand the anonymous snippet whose body is stored in `my_snippet`.

## context

By default, a snippet is used to expand the text before the cursor only if it's
matched by the tab_trigger (keyword, regex).
And a tab_trigger can be expanded with only 1 snippet.

You  can  give more  “intelligence”  to  a  snippet  and work  around  those
limitations, by passing it the `e` option.

It will allow you to:

    • make the snippet take into consideration more than just the text before the cursor
    • expand a tab_trigger with more than 1 snippet

To do so, the snippet should be defined using one of those syntaxes:

                                ┌ any python expression
                                │
                                │ If it evaluates to `True`,
                                │ then UltiSnips will use this snippet.
                                │
    snippet tab_trigger "desc" "expr" e


    context "expr"
    snippet tab_trigger "desc" e
                        │      │
                        │      └ you can add more options
                        │
                        └ Contrary to `desc`, which can be surrounded with
                          any character absent from the description,
                          `expr` MUST be wrapped inside double quotes.


Python code invoked from a `context` statement can use the variables:

    ┌────────────────────────────────────┬────────────────────────────────────────────────────┐
    │ snip.visual_mode                   │ v  V  ^V                                           │
    ├────────────────────────────────────┼────────────────────────────────────────────────────┤
    │ snip.visual_text                   │ last visually-selected text                        │
    ├────────────────────────────────────┼────────────────────────────────────────────────────┤
    │ snip.last_placeholder              │ last active placeholder from previous snippet      │
    │ snip.last_placeholder.current_text │ text in the placeholder on the moment of selection │
    │ snip.last_placeholder.start        │ placeholder start on the moment of selection       │
    │ snip.last_placeholder.end          │ placeholder end on the moment of selection         │
    └────────────────────────────────────┴────────────────────────────────────────────────────┘

    The last 3 properties may not exist.
    You need  to test  whether `snip.last_placeholder`  is different  than None,
    before trying to use them:

            if snip.last_placeholder:
                var = snip.last_placeholder.current_text

### Examples

    snippet r "" "re.match('^\s+if err ', snip.buffer[snip.line-1])" be
    return err
    endsnippet

            Will be expanded into 'return err'  only if the previous line begins
            with 'if err'.


    snippet i "" "re.match('^\s+[^=]*err\s*:?=', snip.buffer[snip.line-1])" be
    if err != nil {
        $1
    }
    endsnippet

    snippet i "" b
    if $1 {
        $2
    }
    endsnippet

            Will be  expanded with the 1st  snippet if the previous  line begins
            with sth like 'err :='. Otherwise the 2nd snippet will be used.

            It works  because context snippets are  PRIORITIZED over non-context
            ones. It  allows to  use  non-context snippets  as  fallback, if  no
            context was matched.


    global !p
    import my_utils
    endglobal

    snippet , "" "my_utils.is_return_argument(snip)" ie
    , `!p
    if my_utils.is_in_err_condition():
        snip.rv = "err"
    else:
        snip.rv = "nil"
    `
    endsnippet

            Will be expanded only if the cursor is located in the return statement.
            Will be expanded either into 'err'  or 'nil' depending on which 'if'
            statement it's located in.

            `is_return_argument()`  and `is_in_err_condition()`  are  part of  a
            custom python module which is called `my_utils`.

            The evaluation of:

                    my_utils.is_return_argument(snip)

            … is available in the `snip.context` variable inside the snippet.

                                               NOTE:

            By  moving the  python expression  into  a named  function inside  a
            module, and  by importing  the latter  from a  global block,  we can
            re-use the expression in other snippets in the same file.


    snippet + "" "re.match('\s*(.*?)\s*:?=', snip.buffer[snip.line-1])" ie
    `!p snip.rv = snip.context.group(1)` += $1
    endsnippet

            That snippet  will be  expanded into  'var1 +='  after a  line which
            begins with 'var1 :='.


                                         ┌ automatically
                                         │
    snippet = "" "snip.last_placeholder" Ae
    `!p snip.rv = snip.context.current_text` == 0
    endsnippet

            Will be expanded only if you  press `=` while a tabstop is currently
            selected in  another snippet. The latter  will be replaced  with the
            original tabstop value followed by ' == 0'.

            This  shows  how you  can  capture  the  placeholder text  from  the
            previous snippet.


                                               NOTE:

            How can you be sure that the snippet will be expanded only while a tabstop
            is currently selected in another snippet?

            Because the expression is  `snip.last_placeholder`. Thus, it will be
            true iff  this variable exists. That  is iff a tabstop  is currently
            selected in another snippet.


                                               NOTE:

            For this to work, you need to choose a single-character tab_trigger.
            Also, the expression `snip.last_placeholder`  is not precise enough.
            Currently,  it will  be expanded  when you  press `=`,  while you're
            selecting a tabstop of ANY snippet.
            It should be expanded only in the snippet for which it was intended.
            You'll need to add a condition. Ex:

                    snip.last_placeholder and snip.last_placeholder.current_text == 'else'

                            only if the current tabstop contains the text 'else'

                    snip.last_placeholder and re.match(r'^\s*for\b', snip.buffer[snip.line])

                            only if the previous line begins with the keyword `for`


                                               NOTE:

            By default, the `snip` object has no `current_text` property.
            And yet this code works and refers to `snip.context.current_text`.
            How does it work?

            In a context snippet, the evaluation of the expression is assigned
            to `snip.context`. Here, the expression is `snip.last_placeholder`.
            So, when the interpolation is applied:

                    snip.context = snip.last_placeholder

            … which means:

                    snip.context.current_text = snip.last_placeholder.current_text


                                               NOTE:

            More generally, a single-character tab_trigger combined with the options `Ae` allows you
            to include a snippet inside a snippet.

            And the inner snippet can itself contain tabstops:

                    snippet test
                    ${1:foo} ${2:bar}
                    endsnippet

                    snippet + "" "snip.last_placeholder" Ae
                    ${1:baz} ${2:qux}
                    endsnippet

            The process can be repeated as many times as you want.
            With one minor issue:
            the 1st time you try to expand a snippet from another snippet, it will work.
            The next times, it won't work from the 1st tabstop.

            You can get around this issue, by moving to the next tabstop and coming back:

                    test
                    →
                    foo bar
                    └─┤
                      └ 1st tabstop of the 1st snippet is selected

                        ┌ tab_trigger of inner snippet
                        │
                    foo + bar
                    →
                    baz qux bar

                                  ┌ go to 2nd inner tabstop (Tab),
                                  │ then come back (S-Tab),
                                  │ and expand a 3rd inner snippet (+)
                        ┌─────────┤
                    baz Tab S-Tab + qux bar
                    →
                    baz qux qux bar


    global !p
    def my_cond1(snip):
        return snip.line % 2 == 0 and snip.column == 1
    def my_cond2(snip):
        return snip.line % 2 == 1 and snip.column == 1
    endglobal

    context "my_cond1(snip)"
    snippet xy "" e
    context1
    endsnippet

    context "my_cond2(snip)"
    snippet xy "" e
    context2
    endsnippet

    snippet xy ""
    non-context
    endsnippet

            xy            context1
            xy        →   context2
                xy            non-context

            You can have several snippets using the same tab_trigger and the option `e`.

            UltiSnips will  test each  of them,  and use the  one for  which the
            expression is true.

            If the expression of several of them is true, they will be listed to
            let the user choose one.

            If none of them  has a true expression, and a  snippet uses the same
            tab_trigger without `e`, the latter will be used as a fallback.

            These rules allow you to expand a tab_trigger in as many ways as you
            want, depending on the contents of the buffer.

## pre_expand

Python code invoked from a `pre_expand` statement is invoked right after trigger
condition was  matched, but before snippet  actually expanded.  It can  use this
variable:

        • snip.visual_content

          Text that was selected before snippet expansion (similar to $VISUAL placeholder).
          It's the only statement from which we can refer to this variable.

If the code needs to modify the line where the trigger was matched, then it will
have to invoke `snip.cursor.set(x,y)` with the desired cursor position.
And, in that case, UltiSnips will not remove the tab_trigger: the code should do
it itself.

## post_expand

Python  code invoked  from  a  `post_expand` statement  is  invoked right  after
snippet was  expanded and  interpolations was  applied for  the first  time, but
before jump on the first placeholder.

No special variable/method.

## post_jump

Python code invoked from a `post_jump`  statement is invoked right after jump to
the next/prev placeholder. It can use these variables:

        ┌─────────────────────────────────┬─────────────────────────────────────────┐
        │ snip.jump_direction             │ 1: forwards, -1: backwards              │
        ├─────────────────────────────────┼─────────────────────────────────────────┤
        │ snip.tabstop                    │ number of tabstop jumped unto           │
        ├─────────────────────────────────┼─────────────────────────────────────────┤
        │ snip.tabstops                   │ list of tabstops objects                │
        ├─────────────────────────────────┼─────────────────────────────────────────┤
        │ snip.tabstops[123].current_text │ text inside the 123th tabstop           │
        ├─────────────────────────────────┼─────────────────────────────────────────┤
        │ snip.tabstops[123].start        │ (line, column) of its starting position │
        │ snip.tabstops[123].end          │ (line, column) of its ending position   │
        └─────────────────────────────────┴─────────────────────────────────────────┘

## interpolation

An interpolation may be applied several times, because of dependencies between
different text-objects.
The 1st time, it's applied after `pre_expand` but before `post_expand`.

In a python interpolation, you can use the variables:

   ┌───────────────┬────────────────────────────────────────────────────────────────┐
   │ snip.basename │ current filename, with extension removed                       │
   ├───────────────┼────────────────────────────────────────────────────────────────┤
   │ snip.fn       │ current filename                                               │
   ├───────────────┼────────────────────────────────────────────────────────────────┤
   │ snip.ft       │ current filetype                                               │
   ├───────────────┼────────────────────────────────────────────────────────────────┤
   │ path          │ complete path to the current file                              │
   ├───────────────┼────────────────────────────────────────────────────────────────┤
   │ t             │ The values of the placeholders, t[1] is the text of ${1}, etc. │
   └───────────────┴────────────────────────────────────────────────────────────────┘

The 'snip' object provides a few methods:

    snip.rv = "foo\n"
    snip.rv += snip.mkline("bar\n")

            Assuming the level of indentation of the line (where the interpolation
            is applied) is 4, it returns:

                foo
                bar

            OTOH:

                    snip.rv = "foo\n"
                    snip.rv += snip.mkline("bar\n")

            … would have returned:

                foo
            bar

            IOW, `snip.mkline()` allows to copy the level of indentation of the previous line.
            The latter can be changed via:

                    • snip.shift()
                    • snip.unshift()
                    • snip.reset_indent()


    snip += line

            Equivalent to:
            snip.rv += '\n' + snip.mkline(line)


    snip.shift(123)
    snip >> 123

            Increases the default  indentation level used by `mkline()` by the
            number of spaces defined by 'shiftwidth', 123 times.

    snip.unshift(123)
    snip << 123

            Decreases the  default indentation level  used by `mkline()`  by the
            number of spaces defined by 'shiftwidth', 123 times.

    snip.reset_indent()

            Resets the indentation level to its initial value.


    snip.rv = "i1\n"
    snip.rv += snip.mkline("i1\n")
    snip.shift(1)
    snip.rv += snip.mkline("i2\n")
    snip.unshift(2)
    snip.rv += snip.mkline("i0\n")
    snip.shift(3)
    snip.rv += snip.mkline("i3")`

            Returns:

                i1
                i1
                    i2
            i0
                        i3


    snip.opt(var, default)

            Returns the value of `var` (can be a variable or an option).
            If it doesn't exist, returns `default`.

The 'snip' object provides some properties as well:

    snip.rv

            'rv' is  the return  value, the  text that  will replace  the python
            block  in the  snippet definition. It  is initialized  to the  empty
            string.

    snip.c

            The  text  currently  in  the python  block's  position  within  the
            snippet.  It  is set  to empty  string as  soon as  interpolation is
            completed.

            Thus:

                    if snip.c != ''
            or
                    if not snip.c

            … makes sure that the interpolation is only done once.
            You can read this last statement as:

                    “if the tabstop has not yet a current value”

            Usage example:

                    snippet uuid "UUID" b
                    `!p
                    import uuid
                    if not snip.c:
                        snip.rv = uuid.uuid4().hex
                    `
                    endsnippet

            Without `if not snip.c`, you'll get the error:

                    'The snippets content did not converge: Check for Cyclic '

            Since there can be dependencies between text objects, UltiSnips runs
            each of them several times  (until they no longer change). Which can
            be  an issue  for random  strings, because  their value  will always
            change, and thus never “converge”.

                    https://github.com/SirVer/ultisnips/issues/375#issuecomment-55115227

            `if not snip.c` can be used to prevent “cyclic” dependencies:

                    One text  object (A)  depends on  another (B),  which itself
                    depends on (A).   When UltiSnips will evaluate  (A), it will
                    affect (B), which will affect (A)…

    snip.p

            Last  selected  placeholder. Will  contain placeholder  object  with
            following properties:

            ┌─────────────────────┬────────────────────────────────────────────────────┐
            │ snip.p.current_text │ text in the placeholder on the moment of selection │
            ├─────────────────────┼────────────────────────────────────────────────────┤
            │ snip.p.start        │ placeholder start on the moment of selection       │
            ├─────────────────────┼────────────────────────────────────────────────────┤
            │ snip.p.end          │ placeholder end on the moment of selection         │
            └─────────────────────┴────────────────────────────────────────────────────┘

    snip.v

            Info about the `${VISUAL}` placeholder. The property has two attributes:

                    • snip.v.mode   v  V  ^V
                    • snip.v.text   text that was selected

