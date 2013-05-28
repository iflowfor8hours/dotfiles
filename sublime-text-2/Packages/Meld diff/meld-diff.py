import sublime, sublime_plugin
import os

MELD_BIN_PATH = '/usr/bin/meld'

class MeldWrapper:
    def run(self, files):
        lenFiles = len(files)
        if (lenFiles == 2):
            os.system('%s "%s" "%s" &' %(MELD_BIN_PATH, files[0], files[1]))
        if (lenFiles == 3):
            os.system('%s "%s" "%s" "%s" &' %(MELD_BIN_PATH, files[0], files[1], files[2]))
        return

class MeldDiffCommand(sublime_plugin.WindowCommand):
    def run(self, files):
        MeldWrapper().run(files)

    def is_visible(self, files):
        if (os.path.exists(MELD_BIN_PATH)):
            lenFiles = len(files)
            return (lenFiles >= 2 and lenFiles <= 3)
        return false

class MeldDiffQuickPanelCommand(sublime_plugin.WindowCommand):
    def run(self, index=None):
        self.open_files = self.__current_open_files()

        if len(self.open_files) > 0:
            self.window.show_quick_panel(self.open_files, self.__meld)
        else:
            sublime.status_message("No other open files")

    def __meld(self, index):
        if index >= 0:
            MeldWrapper().run([self.window.active_view().file_name(), self.open_files[index]])

    def __current_open_files(self):
        files = [view.file_name() for view in self.window.views()]

        # Ignores current file
        files.remove(unicode(self.window.active_view().file_name()))

        return files
