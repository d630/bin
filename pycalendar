#!/usr/bin/env python2
#
# Display calendar.
# Source: https://github.com/vain/bin-pub/blob/master/pycal
# Licence: https://github.com/vain/bin-pub/blob/master/LICENSE

import gtk
import sys

dlg = gtk.Dialog('Calendar')
dlg.set_has_separator(False)
dlg.vbox.pack_start(gtk.Calendar())
dlg.show_all()

if len(sys.argv) >= 2:
    _, x, y, _ = gtk.gdk.display_get_default().get_pointer()
    w, h = dlg.get_size()
    dlg.move(x - w, y - h)

dlg.run()

# vim: set ft=python :
