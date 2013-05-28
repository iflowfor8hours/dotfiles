import sublime, sublime_plugin
import os

MELD_BIN_PATH = '/usr/bin/meld'

class MeldDiffCommand(sublime_plugin.WindowCommand):
    def run(self, files):
        lenFiles = len(files)
        if (lenFiles == 2):
            os.system('%s "%s" "%s" &' %(MELD_BIN_PATH, files[0], files[1]))
        if (lenFiles == 3):
            os.system('%s "%s" "%s" "%s" &' %(MELD_BIN_PATH, files[0], files[1], files[2]))
        return

    def is_visible(self, files):
        if (os.path.exists(MELD_BIN_PATH)):
            lenFiles = len(files)
            return (lenFiles >= 2 and lenFiles <= 3)
        return false