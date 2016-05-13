# https://gist.github.com/idleberg/03bc3766c760bb4b81e3

import os, stat, sublime, sublime_plugin

# Array of files, relative to package directory
files = [
    'nsis_build.sh'
]

def plugin_loaded():
    from package_control import events
    
    # Get name of package folder
    me = os.path.basename(os.path.dirname(os.path.realpath(__file__)))

    if (events.install(me) or events.post_upgrade(me)) and os.name is 'posix' or 'mac':
        for file in files:

            # Concat full path
            file_path = sublime.packages_path() + '/' + me + '/' + file

            # Change permissions, if file exists
            if os.path.isfile(file_path):
                st = os.stat(file_path)
                os.chmod(file_path, st.st_mode | stat.S_IEXEC)
