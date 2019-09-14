# How to securely edit `/etc/sudoers.d/my_modifications`?

    $ sudo visudo -f /etc/sudoers.d/my_modifications

## How to backup/version control this file?

It's a sensitive file, and owned by root so cloning it could be tricky
(`sudo config pull ...`?).

And if the  cloning fails and we end  up with a corrupted file,  `sudo` could be
broken.

