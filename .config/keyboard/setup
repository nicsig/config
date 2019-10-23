#!/bin/bash

# WARNING: Do *not* run this script from a terminal.{{{
#
# It would pollute the environment of any process started by xbindkeys.
#
# If  you do  it  by accident,  run  the  script again,  but  directly from  the
# application launcher of your desktop environment.
# Just write the full path to the script without the tilde (expand it yourself).
#}}}
# TODO:
# We shoul  install a systemd service,  so that we re-run  this script properly,
# without risking to pollute the environment of xbindkeys.
# But that's tricky.
# Read our todo in `~/wiki/admin/systemd.md`.

[[ -d "${HOME}/log" ]] || mkdir "${HOME}/log"
LOGFILE="${HOME}/log/keyboard_$(basename "$0" .sh).log"

main() {
  cat <<-EOF

	-----------
	$(date +%m-%d\ %H:%M)
	-----------

	EOF

  xkbcomp -I"${HOME}/.config/keyboard/xkb" "${HOME}/.config/keyboard/xkb/map" "${DISPLAY}"

  killall xbindkeys
  xbindkeys -f "${HOME}/.config/keyboard/xbindkeys.conf"

  killall xcape
  xcape -e 'Control_L=Escape'
  xcape -e 'Control_R=Return'

  # Purpose:{{{
  #
  # Make  the keypresses  faster and  the  delay between  a pause  and a  keypress
  # shorter.
  #
  # The default values are `500` and `20`.
  # To find the current values, run `$ xset -q`.
  #
  #           ┌ delay before a keypress is sent to the application
  #           │   ┌ maximum number of times a key can be repeated per second
  #           │   │}}}
  # We don't use the same values in `/etc/rc.local` for `kbdrate(8)`, because the result would be slower than under X.{{{
  #
  # You can  measure the  speed by  running `$ time  cat` in  a tmux  pane, then
  # keeping the space key pressed in  another pane until you've filled 10 lines,
  # and  finally pressing  `C-d` in  the  previous pane  where `$  time cat`  is
  # running.
  #}}}
  xset r rate 175 40
}

main 2>&1 | tee -a "${LOGFILE}"




#    # Old keysyms for backspace, tab, enter, ², shift_r, capslock keys:
#    #
#    # keycode  22 = BackSpace BackSpace BackSpace BackSpace
#    # keycode  23 = Tab ISO_Left_Tab Tab ISO_Left_Tab
#    # keycode  36 = Return NoSymbol Return
#    # keycode  49 = oe OE oe OE leftdoublequotemark rightdoublequotemark leftdoublequotemark
#    # keycode  62 = Shift_R NoSymbol Shift_R
#    # keycode  66 = Caps_Lock NoSymbol Caps_Lock
#
#
#    # Goal: CapsLock as Control when hold
#    #
#    # Make CapsLock generate `Control_L`.
#    xmodmap -e 'keycode 66 = Control_L'
#    # Make sure that the modifier map is aware that a new keycode can generate `Control_L`.
#    xmodmap -e 'clear lock'
#    xmodmap -e 'add control = Control_L'
#    # What's the syntax of the `xcape` command?{{{
#    #
#    #     xcape -e '<keysym1>=<keysym2>'
#    #
#    # Whenever `xcape` intercepts a brief  `<keysym1>`, it will translate the latter
#    # into `<keysym2>`.
#    #
#    # Note that there's NO space around the equal sign used for the assignment.
#    #}}}
#    # Replace a single and brief `Control_L` with `Escape`, so that the CapsLock key
#    # can be used as `Escape`.
#    xcape -e 'Control_L=Escape'
#    # Side-effect:
#    # now  the left  control key,  when  pressed briefly  and released  on its  own,
#    # generates `Escape`.
#    # Same thing for any physical key producing `Control_L`.
#
#
#    # Goal: Enter as Control when hold
#    #
#    # Make Enter generate the keysym `Control_R`.
#    xmodmap -e 'keycode 36 = Control_R'
#    # Make sure that the modifier map is aware that a new keycode can generate `Control_R`.
#    xmodmap -e 'add control = Control_R'
#    # There's no keycode generating `Return` anymore. We need one, otherwise
#    # `xcape` won't be able to send any keycode to the kernel.
#    xmodmap -e 'keycode 255 = Return'
#    # Replace a single `Control_R` into `Return`.
#    xcape -e 'Control_R=Return'
#    # Side-effect: now the right control key, when pressed and released on its own, generates `Return`.
#
#
#    # # Goal: backspace as Alt when hold
#    # #
#    # # Make the `BackSpace` key generate the modifier keysym `Meta_L`.
#    # xmodmap -e 'keycode  22 = Meta_L'
#    # # Make sure that the modifier map is aware that a new keycode can generate `Meta_L`.
#    # xmodmap -e 'add mod1 = Meta_L'
#    # # There's no keycode generating `BackSpace` anymore. We need one, otherwise
#    # # `xcape` won't be able to send any keycode to the kernel.
#    # xmodmap -e 'keycode 253 = BackSpace'
#    # # Replace a single `Meta_L` into a `BackSpace` (to restore the backspace).
#    # xcape -t 100 -e 'Meta_L=BackSpace'
#    # # Side-effect: now any key generating `Meta_L` will now generate `BackSpace` when hit alone.
#
#
#    # # Goal: tab as AltGr when hold
#    # #
#    # # Make the Tab key generate the modifier keysym `Hyper_L` when it's hold:
#    # xmodmap -e 'keycode 23 = Hyper_L'
#    # # In the modifier map, change the meaning of a `Hyper_L`, from `mod4` to `AltGr` (mod5).
#    # xmodmap -e 'remove mod4 = Hyper_L'
#    # # FIXME:
#    # # The next command break AltGr inside Firefox. Can't insert special characters
#    # # ([], {}, (), |, …) in an input field.
#    # xmodmap -e 'add mod5 = Hyper_L'
#    # # There's no keycode generating `Tab` anymore. We need one.
#    # xmodmap -e 'keycode 254 = Tab'
#    # # Replace a single `Hyper_L` by a `Tab`.
#    # xcape -e 'Hyper_L=Tab'
#
#
#    # Make the upper-left `²` key generate the modifier keysym `Mode_switch` when it's held.
#    xmodmap -e 'keycode 49 = Mode_switch'

