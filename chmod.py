import os, stat, sublime, sublime_plugin

def plugin_loaded():
    from os.path import join
    from package_control import events

    package = "NSIS"
    script  = join(sublime.packages_path(), package + "/nsis_build.sh")

    # chmod +x <script>
    if (events.install(package) or events.post_upgrade(package)) and os.name is 'posix' or 'mac':
        st = os.stat(script)
        os.chmod(script, st.st_mode | stat.S_IEXEC)
