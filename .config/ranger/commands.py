# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *

# A simple command for demonstration purposes follows.
#------------------------------------------------------------------------------

# You can import any python module as needed.
import os

# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command): #{{{1
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.actions, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    def tab(self):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()
# }}}1

# fasd {{{1

# Source: https://github.com/ranger/ranger/wiki/Custom-Commands#visit-frequently-used-directories

class fasd(Command):
    # fasd integration
    # Usage:
    #     :fasd partial_dirname Enter
    """
    :fasd

    Jump to directory using fasd
    """
    def execute(self):
        import subprocess
        arg = self.rest(1)
        if arg:
            directory = subprocess.check_output(["fasd", "-d"]+arg.split(), universal_newlines=True).strip()
            self.fm.cd(directory)

# fzf_fasd {{{1

class fzf_fasd(Command):
    """
    :fzf_fasd

    Find a frecent file using fzf.

    With a prefix argument find only directories.
    """
    def execute(self):
        import subprocess
        import os.path
        command='fasd ' \
                + ('-d' if self.quantifier else '') \
                + " | awk '{ print $2 }'" \
                + " | fzf -e -i --tac --no-sort --preview '(highlight -O ansi {} || cat {}) 2>/dev/null'"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

# fzf_find {{{1

# Source: https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration

class fzf_find(Command):
    """
    :fzf_find

    Find a file using fzf.

    With a prefix argument find only directories.
    """
    def execute(self):
        import subprocess
        import os.path
        # Alternative using `$ fd`:{{{
        #
        #     command="fd -L " + ("-t d" if self.quantifier else "") + " -E /proc 2>/dev/null | fzf"
        #}}}
        command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune" \
                + " -o " \
                + ("-type d" if self.quantifier else "") \
                + " -print 2>/dev/null | sed 1d | cut -b3-" \
                + " | fzf +m --preview '(highlight -O ansi {} || cat {}) 2>/dev/null'"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

# mkcd {{{1

# Source: https://github.com/ranger/ranger/wiki/Custom-Commands#mkcd-mkdir--cd

class mkcd(Command):
    # If you only care about creating a directory (without entering it), you can run `:shell mkdir`, or simply `:mkdir`.{{{
    #
    # `:mkdir` works because it's defined in `commands_full.py`.
    # `:shell mkdir` works because `mkdir` is a shell command.
    #}}}
    """
    :mkcd <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):
        from os.path import join, expanduser, lexists
        from os import makedirs
        import re

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)

            match = re.search('^/|^~[^/]*/', dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0):]

            for m in re.finditer('[^/]+', dirname):
                s = m.group(0)
                if s == '..' or (s.startswith('.') and not self.fm.settings['show_hidden']):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console('scout -ae ^{}$'.format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)

# toggle_flat {{{1

class toggle_flat(Command):
    """
    :toggle_flat

    Flattens or unflattens the directory view.

    Warning: Don't run this in a big directory like `/`, `~` or `~/.vim`!
    A few thousands files should be ok.
    A few tens of thousands files will not (too slow to generate, too slow to navigate).
    """

    def execute(self):
        if self.fm.thisdir.flat == 0:
            self.fm.thisdir.unload()
            self.fm.thisdir.flat = -1
            self.fm.thisdir.load_content()
        else:
            self.fm.thisdir.unload()
            self.fm.thisdir.flat = 0
            self.fm.thisdir.load_content()

