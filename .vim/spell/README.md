# What's this `cleanadd.vim` script?

See `:h spellfile-cleanup`.

# Where did you get it?

        $VIMRUNTIME/spell/cleanadd.vim.

# Why did you copy it here?

It's absent from Neovim,  and I want to source it from  time to time, regardless
of what I use (Vim or Neovim).

The |zw| command turns existing entries in 'spellfile' into comment lines.
This avoids having to write a new file  every time, but results in the file only
getting longer, never shorter.
To clean up the comment lines in all '.add' spell files execute this:

        :runtime spell/cleanadd.vim

