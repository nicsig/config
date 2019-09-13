# Where did you get those files?

    $ sudo add-apt-repository ppa:pi-rho/dev
    $ sudo sed -i.bak 's/^#\s*deb-src/deb-src/' /etc/apt/sources.list.d/pi-rho-ubuntu-dev-$(lsb_release -sc).list
    $ sudo aptitude update

    $ cd /tmp
    $ apt-get source rxvt-unicode
    $ ls -1 rxvt-unicode-9.22/debian/patches/
    00-256resources.patch~
    00-font-width-fix.patch~
    00-line-spacing-fix.patch~
    01_app-defaults.diff~
    02_use_dejavu.diff~
    07_rgb_location.diff~
    11_fix_lexgrog.diff~
    12_hyphen_minus_sign.diff~

Don't run  `$ apt-get source` with  `sudo(8)`; it raises a  (harmless?) error at
the end of the download:

    W: Can't drop privileges for downloading as file 'rxvt-unicode_9.22.orig.tar.bz2' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)~

## Can I get them without using a PPA?

You can try to download the source code of the rxvt-unicode package from the default repo:

    $ sudo sed -i.bak "s/^#\s*deb-src\(.*$(lsb_release -sc) universe.*\)/deb-src\1/" sources.list
    $ sudo aptitude update
    $ cd /tmp
    $ apt-get source rxvt-unicode=9.21-1build1
    $ ls -1 rxvt-unicode-9.21/debian/patches/
    01_app-defaults.diff~
    02_use_dejavu.diff~
    03_fix_xterm_scrollbar.diff~
    04_no_urgency_on_focus.diff~
    05_cutchars.diff~
    06_debian_docs.diff~
    07_rgb_location.diff~
    09_binutils_gold.diff~
    10_metabit.diff~
    11_fix_lexgrog.diff~
    12_hyphen_minus_sign.diff~
    13_section_mismatch.diff~
    14_pod_errors.diff~
    15_perl_518.diff~

Note that this package does not contain these patches:

    256resources.patch~
    font-width-fix.patch~
    line-spacing-fix.patch~

##
# How can they be useful?

Before compiling urxvt, you can apply those patches to improve the binary or fix
various issues.

# How to apply them?

See `~/wiki/urxvt.md`.
And search for `# Installation`, `## By Compiling`, `### apply patches`.

