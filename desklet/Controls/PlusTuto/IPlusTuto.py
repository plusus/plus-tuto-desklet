from libdesklets.controls import Interface, Permission


class IPlusTuto(Interface):
    tuto_num = Permission.READ
    launch_tuto_center = Permission.READ
