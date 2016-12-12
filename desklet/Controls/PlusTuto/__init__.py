import os
from subprocess import Popen
from libdesklets.controls import Control
from libtuto.done_tutorials import count_tutorials_todo
from libtuto.persistence_dbus import register_todo_update

from IPlusTuto import IPlusTuto


class PlusTuto(Control, IPlusTuto):

    def __init__(self):
        Control.__init__(self)
        register_todo_update(lambda: self._update("tuto_num"))

    def __get_tuto_num(self):
        return count_tutorials_todo()

    def __launch_tuto_center(self):
        Popen(['nohup', 'plustutocenter'],
              stdout=open('/dev/null', 'w'),
              stderr=open('/dev/null', 'w'),
              preexec_fn=os.setpgrp)
        return True

    tuto_num = property(__get_tuto_num,
                        doc="tutorials left to be done")
    launch_tuto_center = property(__launch_tuto_center,
                                  doc="tutorial center launcher")


def get_class(): return PlusTuto




