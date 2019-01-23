Don't forget you can:

   - navigate in the jumplist with C-o and C-i
   - open the index with Tab
   - collapse/expand all entries in the index with H/L

# Mapppings

You can install mappings in 3 modes:

   - normal (default)
   - fullscreen
   - index (TOC accessed via Tab)

To do so, you need to pass  the optional argument `[fullscreen]` or `[index]` to
the `:map` command. For more info:

        :man zathurarc
        /Mode

Example:

        map  [fullscreen]  f  toggle_fullscreen

# Add support for more type of files

Go to mime settings, and choose zathura to open `.djvu` files.
Then, install this plugin:

        sudo aptitude install zathura-djvu

Do the same for `.ps` and `.cb` files:

                                      ┌ PostScript support for zathura
                                      │
        sudo aptitude install zathura-ps
        sudo aptitude install zathura-cb
                                      │
                                      └ comic book archive support for zathura

