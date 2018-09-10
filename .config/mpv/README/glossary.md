# aspect ratio

The proportional relationship between the width and the height of your screen.

It is commonly expressed as two numbers separated by a colon, as in 16:9.

By default, the `mpv` window probably inherits the aspect ratio of your screen.

# brightness, contrast, gamma, saturation

Let's assume that the color of each pixel is encoded with 4 numbers between 0-255:

    • amount of light
    • amount of red
    • amount of green
    • amount of blue

When you increase  the saturation, you increase the amount  of red/green/blue in
each pixel.

---

When you  increase the brightness, you  increase the amount of  light emitted by
each pixel.

---

When you  increase the contrast:

        • you increase the  amount of light emitted by each  pixel whose
          original amount of light was between 0-127

        • you decrease the  amount of light emitted by each  pixel whose
          original amount of light was between 128-255

---

When you increase  the gamma, you increase  the amount of light  emitted by each
pixel.
The  more the  original amount  was  bright (255)  or  dark (0),  the less  it's
affected by the gamma change.

This allows you to make details appear in SLIGHTLY dark areas of an image, while
minimizing the effect on VERY dark/bright areas.
IOW, contrary  to brightness which  affects the pixels UNIFORMLY,  gamma affects
them PROPORTIONALLY to how close to 127 their current level of light.

Usually, it's  advised to increase gamma  just enough to distinguish  details in
the most dark areas of the screen.

        https://www.vegascreativesoftware.info/us/forum/difference-contrast-vs-gamma--27019/

# OSD

On-Screen Display:

        https://en.wikipedia.org/wiki/On-screen_display

It's the bar displaying the timestamp when we press `o`.

# OSC

On-Screen Control.

It's  the bar  displayed when  we pause  a  video, and  allowing us  to move  to
different timestamps via the mouse.

It provides us other features, all controlled via the mouse, such as cycling the
subtitles, or entering fullscreen mode.

# property

It's used to:

        • set an option during runtime (e.g. `speed` property vs `--speed` option)
        • query arbitrary information  (e.g. `filename` property)

---

You can find the list of all available properties in `$ man mpv` (COMMAND
INTERFACE > Property list).

---

In `$ man mpv` (COMMAND INTERFACE > property expansion), a property name is
annotated with RW to indicate whether it's generally writable.

