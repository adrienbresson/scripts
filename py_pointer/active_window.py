#def get_active_window_title(self):
#    root = Popen(['xprop', '-root', '_NET_ACTIVE_WINDOW'], stdout=PIPE)
#
#    for line in root.stdout:
#        m = re.search('^_NET_ACTIVE_WINDOW.* ([\w]+)$', line)
#        if m != None:
#            id_ = m.group(1)
#            id_w = Popen(['xprop', '-id', id_, 'WM_NAME'], stdout=PIPE)
#            break
#
#    if id_w != None:
#        for line in id_w.stdout:
#            match = re.match("WM_NAME\(\w+\) = (?P<name>.+)$", line)
#            if match != None:
#                return match.group("name")
#
#    return "Active window not found"
#
#get_active_window_title(self)

###import wnck
###screen = wnck.screen_get_default()
###window_list = screen.get_windows()
###print 'window list: %r' % window_list
###active_window = screen.get_active_window()

from gi.repository import Gtk, Wnck

Gtk.init([])  # necessary if not using a Gtk.main() loop
screen = Wnck.Screen.get_default()
screen.force_update()  # recommended per Wnck documentation

window_list = screen.get_windows()
active_window = screen.get_active_window()

print 'active window: %r' % active_window
