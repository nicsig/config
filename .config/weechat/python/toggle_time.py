# Usage:{{{
#
# bind a key with your format, for example:
#
#     /key bind meta-t /toggle_time %H:%M:%S
#}}}

import weechat
def cmd_cb(data, buffer, args):
    if weechat.config_string(weechat.config_get('weechat.look.buffer_time_format')):
        args = ''
    weechat.command('', '/mute set weechat.look.buffer_time_format "%s"' % args)
    return weechat.WEECHAT_RC_OK

weechat.register(
                 'toggle_time',    # internal name of the script
                 'lacygoill',      # author name of the script
                 '1.0',            # script version
                 'GPL3',           # license
                 'Toggle timestamp in buffers',    # description
                 '',    # name of function called when script is unloaded (shutdown_function)
                 ''     # script charset (if your script is UTF-8, you can use blank value here, because UTF-8 is default charset)
                )
weechat.hook_command(
                     'toggle_time',
                     'foo',
                     'bar',
                     'baz',
                     'qux',
                     'cmd_cb',
                     'norf',
                    )
