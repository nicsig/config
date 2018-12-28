# Why is there a cloc binary here?

Atm, the cloc binary installed through the ubuntu repo is too old, and sometimes
fails to compute the number of lines of code in a repo (such as Vim):

        Can't use an undefined value as an ARRAY reference at /usr/bin/cloc 1498

So, we install here a more recent version:

        https://github.com/AlDanial/cloc/releases/

