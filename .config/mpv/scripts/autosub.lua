-- requires subliminal, version 1.0 or newer (install from your repo or via `pip`)
-- default keybinding: M-s
-- add the following to your input.conf to change the default keybinding:
--
--     <key> script_binding auto_load_subs

-- TODO: Find a way to get a recent version of `subliminal`.{{{
--
-- This could help finding subtitles more often.
-- Because, as of right now, it rarely finds anything.
-- But I know this lua script works (tested with “A bridge of spies”).
--}}}
local utils = require 'mp.utils'
function load_sub_fn()
    -- use `$ which subliminal` to find the path
    subl = "/usr/bin/subliminal"

    -- There was no `for` loop in the original code.
    -- It only cared about english.
    -- For the syntax of this loop, see:
    --     https://stackoverflow.com/a/7617366/9780968
    langs = {"en", "fr"}
    for i, lang in ipairs(langs) do
        mp.msg.info("Searching subtitle")
        mp.osd_message("Searching subtitle")
        t = {}
        -- Original code:{{{
        --
        --     t.args = {subl, "download", "-s", "-l", "en", mp.get_property("path")}
        --
        -- I changed it because the command failed:
        --
        --     $ /usr/bin/subliminal download -s -l en /path/to/file
        --
        -- Maybe because I use an old version of `subliminal`.
        --
        -- So, instead I execute:
        --
        --     $ /usr/bin/subliminal -l en -- /path/to/file
        --}}}
        t.args = {subl, "-l", lang, "--", mp.get_property("path")}
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
