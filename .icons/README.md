# Where did you find the ComixCursors theme?

<https://www.gnome-look.org/content/show.php/ComixCursors?content=32627>

Click on:

   1. Files
   2. 10 archived
   3. ComixCursors-0.9.0.tar.bz2

# How did you set it as your default cursor theme in xfce?

Click on:

   1. Settings (super + s)
   2. Mouse and Touchpad
   3. Theme

Select your theme.

# It doesn't persist after a reboot!

Make sure sessions are not saved & restored (clear `~/.cache/sessions/` and make
it non-writable); then apply the theme:

    $ lxappearance
    > Mouse Cursor
    > select theme
    > click on "Apply" button

---

Read this:

- <https://forum.xfce.org/viewtopic.php?id=11997>
- <https://bugs.launchpad.net/ubuntu/+source/xfwm4/+bug/157447>
- <https://askubuntu.com/questions/708667/cursor-theme-changes-to-default-after-re-login>

---

Try this:

   1. log out of Xfce
   2. switch over to text console (Ctrl+Alt+F1)
   3. delete the contents of `~/.cache/sessions`
   4. log back in again via the GUI

---

Or this:

   1. Settings
   2. Session and Startup
   3. General
   4. tick “Automatically save session on logout”

Then restart, and see whether the theme persists.
If it does, untick “Automatically save session on logout” and restart again.

