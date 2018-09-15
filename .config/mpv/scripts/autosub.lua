-- Source:
--     https://gist.github.com/selsta/ce3fb37e775dbd15c698

-- requires subliminal, version 1.0 or newer (install from your repo or via `pip`)
-- default keybinding: M-s
-- add the following to your input.conf to change the default keybinding:
--
--     <key> script_binding auto_load_subs

-- Alternative to this script:
--     https://github.com/directorscut82/find_subtitles

-- Why getting a recent version of `subliminal` is important?{{{
--
-- This could help finding subtitles more often.
-- Btw I know this lua script works (tested with “A bridge of spies”).
-- However, it can take some time (several minutes).
--}}}
-- How to get a recent version of `subliminal`?{{{
--
-- You  may  need to  install  various  modules  before  being able  to  install
-- `subliminal`.
-- In case of an error, read the message to try and find the name of the missing
-- dependency.
--
-- I have succeeded the installation like this:
--
--     $ python -m pip install --user setuptools
--     $ python -m pip install --user pytest-runner
--     $ python -m pip install --user subliminal
--       ├───────┘
--       └ https://stackoverflow.com/a/32680082/9780968
--}}}

local utils = require 'mp.utils'
function load_sub_fn()
    -- use `$ which subliminal` to find the path
    subl = "/home/jean/.local/bin/subliminal"
    -- TODO: Get the path to the program dynamically.

    -- There was no `for` loop in the original code.
    -- It only cared about english.
    -- For the syntax of this loop, see:
    --     https://stackoverflow.com/a/7617366/9780968
    langs = {"fr", "en"}
    for i, lang in ipairs(langs) do
        mp.msg.info("Searching subtitle")
        mp.osd_message("Searching subtitle")
        t = {}
        -- Original code:{{{
        --
        --     t.args = {subl, "download", "-s", "-l", "en", mp.get_property("path")}
        --                                  ^^
        --                                  remove that shit!
        --
        -- If you use an old version of `subliminal`, try this instead:
        --
        --     $ /usr/bin/subliminal -l en -- /path/to/file
        --}}}
        t.args = {subl, "download", "-l", lang, mp.get_property("path")}
        res = utils.subprocess(t)
        if res.status == 0 then
            mp.commandv("rescan_external_files", "reselect")
            mp.msg.info("Subtitle download succeeded")
            mp.osd_message("Subtitle download succeeded")
        else
            mp.msg.warn("Subtitle download failed")
            mp.osd_message("Subtitle download failed")
        end
    end
end

mp.add_key_binding("alt+s", "auto_load_subs", load_sub_fn)
