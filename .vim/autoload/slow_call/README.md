# Which files can I use to configure my plugins?

    ~/.vim/plugin/README.md
    ~/.vim/after/plugin/README.md
    ~/.vim/autoload/slow_call/README.md

# What's the purpose of this directory?

You can use it to delay the call to functions installing some interface, because
they are too slow to be processed during Vim's startup, like:

        • lg#motion#repeatable#make#all()
        • operator#sandwich#set()
        • submode#map()

##
# Can a conflict arise between a file in `~/.vim/autoload/` and the `autoload/` of a third-party plugin?

Yes.

For example, if you have the file:

        ~/.vim/plugged/vim-dirvish/autoload/dirvish.vim

You can't have this file:

        ~/.vim/autoload/dirvish.vim

Because,  when a  dirvish  mapping  will call  one  of  its original  autoloaded
function (`dirvish#func()`), Vim will:

        1. iterate over the paths in 'rtp'
        2. for each path, append `autoload/`
        3. enter the resulting directory if it exists
        4. look for a `dirvish.vim` file
        5. look for a `func()` function inside this file

Since `~/.vim/` comes before `~/.vim/plugged/vim-dirvish/` in 'rtp',
Vim will first find `~/.vim/autoload/dirvish.vim`.
It won't find `func()`, because it's defined in `~/.vim/plugged/vim-dirvish/autoload/dirvish.vim`.

But Vim won't look further, it will stop as soon as it finds a file matching the
path before the last `#` in the name of the autoloaded function.
As a result, all the original autoloaded dirvish functions will never be sourced.

# Can the conflict be avoided?

Yes.

If the path to  your file, relative to `autoload/` does not  match any path used
in the name of an autoloaded function, then there's no issue.
For example, you can have these files:

        ~/.vim/autoload/foobar.vim
        ~/.vim/autoload/foo/bar.vim

If, and only if, there's no function whose name match resp. the patterns:

        foobar#.*()
        foo#bar#.*()

# Must I avoid a conflict between a filename here, and a filename in a third-party plugin?

Probably not.

There  should  be no  issue  because  the files  are  in  a subdirectory  called
`slow_call`.
It's unlikely  that the name of  an autoloaded function needed  by a third-party
plugin matches the pattern `slow_call#{your_file}#.*()`.

