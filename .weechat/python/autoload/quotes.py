import subprocess

SCRIPT_NAME = 'quotes'
SCRIPT_AUTHOR = 'Steve Losh <steve@stevelosh.com>'
SCRIPT_VERSION = '1.0'
SCRIPT_LICENSE = 'MIT/X11'
SCRIPT_DESC = 'Grab quotes and shove them into a text file.'
SCRIPT_COMMAND = 'quo'
SCRIPT_COMMAND_LONG = 'quoo'
SCRIPT_COMMAND_COPY = 'cop'

QUOTE_FILE = '/Users/sjl/Dropbox/quotes.txt'
COPY_FILE = '/Users/sjl/.ircopy.irc'

import_ok = True

try:
    import weechat
except ImportError:
    print 'This is a weechat script, what are you doing, run it in weechat, jesus'
    import_ok = False

weechat_version = 0

def hd(fn, name, obj, attr):
    return fn(weechat.hdata_get(name), obj, attr)

def hdp(name, obj, attr):
    return hd(weechat.hdata_pointer, name, obj, attr)

def hds(name, obj, attr):
    return hd(weechat.hdata_string, name, obj, attr)

def get_lines(buffer, numlines):
    lines = hdp("buffer", buffer, "own_lines")
    if not lines:
        # null pointer wat do
        return None

    last_lines = []

    line = hdp("lines", lines, "last_line")
    for _ in range(numlines):
        if not line:
            # shit we're at the top of the buffer
            break

        data = hdp("line", line, "data")
        msg = hds("line_data", data, "message")
        pre = hds("line_data", data, "prefix")

        msg = weechat.string_remove_color(msg, "")
        pre = weechat.string_remove_color(pre, "")

        last_lines.append("<%s> %s" % (pre.strip(), msg.strip()))

        line = hdp("line", line, "prev_line")

    last_lines.reverse()
    return last_lines

def quote_grab(data, buffer, args, numlines=15):
    lines = get_lines(buffer, numlines)

    with open(QUOTE_FILE, 'a') as f:
        f.write("\n---\n")
        f.write('\n'.join(lines))

    subprocess.call(["vim", QUOTE_FILE,
                     # start at the bottom of the file
                     "+",
                     # move up N lines, where N is how many we appended
                     "-c", "normal! %dk" % len(lines)])
    weechat.command("", "/window refresh")

    return weechat.WEECHAT_RC_OK

def quote_grab_long(data, buffer, args):
    return quote_grab(data, buffer, args, 75)

def quote_grab_copy(data, buffer, args):
    lines = get_lines(buffer, 1000)

    with open(COPY_FILE, 'w') as f:
        f.write('\n'.join(lines))

    subprocess.call(["vim", COPY_FILE,
                     # start at the bottom of the file
                     "+"])
    weechat.command("", "/window refresh")

    return weechat.WEECHAT_RC_OK

if __name__ == '__main__' and import_ok:
    if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION,
                        SCRIPT_LICENSE, SCRIPT_DESC, '', ''):
        weechat_version = weechat.info_get('version_number', '') or 0
        weechat.hook_command(
            SCRIPT_COMMAND,
            'Appends the last 15 lines of the current buffer to your quotes '
            'file and opens it in Vim so you can trim it.',
            '',
            '',
            '',
            'quote_grab',
            '')
        weechat.hook_command(
            SCRIPT_COMMAND_LONG,
            'Appends the last 75 lines of the current buffer to your quotes '
            'file and opens it in Vim so you can trim it.',
            '',
            '',
            '',
            'quote_grab_long',
            '')
        weechat.hook_command(
            SCRIPT_COMMAND_COPY,
            'Open the last 1000 lines of the file in Vim so you can copy.',
            '',
            '',
            '',
            'quote_grab_copy',
            '')
