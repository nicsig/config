# Do *not* version control youtube-dl!

It's a binary, so there's nothing to compare between 2 different versions.
And it's big, so it probably dramatically increases the size of the repo.

# Why is there a cloc script here?

Atm, the cloc script installed through the ubuntu repo is too old, and sometimes
fails to compute the number of lines of code in a repo (such as Vim):

    Can't use an undefined value as an ARRAY reference at /usr/bin/cloc 1498

So, we install here a more recent version:

<https://github.com/AlDanial/cloc/releases/>

##
# Where did you find the
## `as-tree` binary?

<https://github.com/jez/as-tree>

Can be useful in Vim to get a tree view of an arbitrary subset of files in the cwd:

    :to 40vnew | .!find . -name '*.vim' 2>/dev/null | as-tree

## `ch` bash script?

<https://github.com/learnbyexample/command_help>

## `fzfimg` script?

<https://github.com/seebye/ueberzug/blob/master/examples/fzfimg.sh>

## `NetalyzrCLI.jar` archive?

- <https://sebsauvage.net/links/?r-awQg>
- <http://www.netalyzr.icsi.berkeley.edu/NetalyzrCLI.jar>
- <https://play.google.com/store/apps/details?id=edu.berkeley.icsi.netalyzr.android>

## `typometer.jar` archive?

- <https://pavelfatin.com/typometer/>
- <https://github.com/pavelfatin/typometer>

##
# git-jump

<https://github.com/git/git/tree/master/contrib/git-jump>

Git-jump is a script for helping you jump to "interesting" parts of your project
in your editor.
It works  by outputting  a set  of interesting spots  in the  "quickfix" format,
which editors like  vim can use as a  queue of places to visit  (this feature is
usually used to jump to errors produced by a compiler).
For example, given a diff like this:

    ------------------------------------
    diff --git a/foo.c b/foo.c
    index a655540..5a59044 100644
    --- a/foo.c
    +++ b/foo.c
    @@ -1,3 +1,3 @@
     int main(void) {
    -  printf("hello word!\n");
    +  printf("hello world!\n");
     }
    -----------------------------------

git-jump will feed this to the editor:

    -----------------------------------
    foo.c:2: printf("hello word!\n");
    -----------------------------------

Or, when running 'git jump grep', column numbers will also be emitted,
e.g. `git jump grep "hello"` would return:

    -----------------------------------
    foo.c:2:9: printf("hello word!\n");
    -----------------------------------

Obviously this trivial case isn't that  interesting; you could just open `foo.c`
yourself.
But when  you have  many changes  scattered across  a project,  you can  use the
editor's support to "jump" from point to point.

Git-jump can generate four types of interesting lists:

  1. The beginning of any diff hunks.

  2. The beginning of any merge conflict markers.

  3. Any grep matches, including the column of the first match on a
     line.

  4. Any whitespace errors detected by `git diff --check`.

## using git-jump

To use it, just drop git-jump in your PATH, and then invoke it like this:

    # jump to changes not yet staged for commit
    git jump diff

    # jump to changes that are staged for commit; you can give
    # arbitrary diff options
    git jump diff --cached

    # jump to merge conflicts
    git jump merge

    # jump to all instances of foo_bar
    git jump grep foo_bar

    # same as above, but case-insensitive; you can give
    # arbitrary grep options
    git jump grep -i foo_bar

    # use the silver searcher for git jump grep
    git config jump.grepCmd "ag --column"

## related programs

You can accomplish some of the same things with individual tools.
For example, you can use `git mergetool` to start vimdiff on each unmerged file.
`git jump merge` is for the vim-wielding luddite who just wants to jump straight
to the conflict text with no fanfare.

As of  git v1.7.2,  `git grep` knows  the `--open-files-in-pager`  option, which
does something similar to `git jump grep`.
However, it is limited to positioning the cursor to the correct line in only the
first file, leaving  you to locate subsequent  hits in that file  or other files
using the editor or pager.
By contrast, git-jump provides the editor  with a complete list of files, lines,
and a column number for each match.

## limitations

This script was written and tested with vim.
Given that the quickfix format is the  same as what gcc produces, I expect emacs
users have a similar feature for iterating  through the list, but I know nothing
about how to activate it.

The shell snippets to generate the quickfix lines will almost certainly choke on
filenames with exotic characters (like newlines).

##
# Todo

We should have a mechanism which regenerates the tags file regularly.
Maybe we should create a git repo specifically for these scripts.
This way, there  would be a `.git/` directory, and  `vim-gutentags` would do the
work...

