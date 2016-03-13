#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright (C) 2015 Ata Niyazov <ata.niazov@gmail.com> & Taner Guven <tanerguven@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import fcntl
import os, sys
import subprocess
import Tkinter as tk
import tkMessageBox
import apt

PROGRAMS = [
    ("Sistem Programlama Programlari", "kouembedded-systemprogramming-course"),
    ("Programlanabilir Yapilar Dersi Programlari", "kouembedded-programmablestructures-course"),
    ("Web Browser (Firefox)", "firefox"),
    ("Ubuntu Software Center", "software-center"),
]

COMPLETION_MESSAGE="echo -e \"\nIslem tamamlandi. Pencereyi kapatabilirsiniz\" && read"

SYSTEM_INFO_MESSAGE="""
# System #
Operating System : %s
KOU Package Installer : %s
"""

PID_FILE = '/run/lock/kouembedded-packageinstaller.pid'

def run(cmd, read_stdout=True, read_stderr=True):
    if read_stdout:
        stdout = subprocess.PIPE
    else:
        stdout = None
    if read_stderr:
        stderr = subprocess.PIPE
    else:
        stderr = None
    p = subprocess.Popen(cmd, shell=True, stdout=stdout, stderr=stderr)
    stdout, stderr = p.communicate()
    return p.returncode, stdout, stderr

def restart_this_process():
    os.execl(sys.argv[0], " ".join(sys.argv))

def get_installed_programs():
    global APT_CACHE
    installed = set()
    uninstalled = set()
    for package_title, package_name in PROGRAMS:
        if package_name not in APT_CACHE:
            print "WARNING: package not found: %s" % package_name
        elif APT_CACHE[package_name].is_installed:
            installed.add(package_name)
        else:
            uninstalled.add(package_name)
    return installed, uninstalled

def configure(install_package_list, remove_package_list):
    install_package_list = " ".join(install_package_list)
    remove_package_list = " ".join(remove_package_list)

    cmd = "xterm -e bash -c 'apt-get -y update && apt-get -y install -o Dpkg::Options::=\"--force-overwrite\" %s && apt-get -y autoremove --purge %s ; %s'" % (
        install_package_list, remove_package_list, COMPLETION_MESSAGE
    )

    print cmd
    run("gksudo -- %s" % cmd)
    restart_this_process()


def system_update():
    cmd = "xterm -e bash -c 'apt-get -y update && apt-get install -f && apt-get -y dist-upgrade && update-kouembedded-xubuntu ; %s'" % COMPLETION_MESSAGE
    print cmd
    run("gksudo -- %s" % cmd)
    restart_this_process()


def system_info():
    INFO_FILE="/tmp/kouembedded-xubuntu.systeminfo"

    try:
        OS_version = open("/var/lib/kouembedded-xubuntu/version").read().replace('\n', '')
    except:
        OS_version = ""

    info = SYSTEM_INFO_MESSAGE % (OS_version, APT_CACHE["kouembedded-packageinstaller"].installed.version)

    installed_packages, uninstalled_packages = get_installed_programs()
    if len(installed_packages) > 0:
        info += "\n# Installed Packages #\n"
        for package_title, package_name in PROGRAMS:
            if package_name in APT_CACHE and APT_CACHE[package_name].is_installed:
                info += "%s : %s\n" % (package_name, APT_CACHE[package_name].installed.version)

    f = open(INFO_FILE, "w").write(info)
    cmd = "xterm -e bash -c 'cat %s ; read'" % INFO_FILE
    run(cmd)


class GUI(tk.Tk):
    def __init__(self):
        tk.Tk.__init__(self)

        self.program_list = []

        installed_packages, uninstalled_packages = get_installed_programs()
        for package_title, package_name in PROGRAMS:
            v = tk.StringVar()
            if package_name in installed_packages:
                v.set(package_name)
            else:
                v.set("")
            cb = tk.Checkbutton(self, text=package_title, variable=v, onvalue=package_name, offvalue="")
            cb.pack()
            self.program_list.append(v)

        self.submitButton = tk.Button(self, text="Kaydet", command=self.query_checkbuttons)
        self.submitButton.pack()

        self.updateButton = tk.Button(self, text="Sistemi Guncelle", command=self.updateButton_clicked)
        self.updateButton.pack()

        self.systemInfoButton = tk.Button(self, text="Sistem Bilgileri", command=self.systemInfoButton_clicked)
        self.systemInfoButton.pack()

    def systemInfoButton_clicked(self):
        self.withdraw()
        try:
            system_info()
        except:
            pass
        self.deiconify()

    def updateButton_clicked(self):
        self.withdraw()
        system_update()
        self.deiconify()

    def query_checkbuttons(self):

        selected = set()
        for var in self.program_list:
            value = var.get()
            if value != "":
                selected.add(value)
        installed, uninstalled = get_installed_programs()
        install_package_list = selected - installed
        remove_package_list = installed - selected

        print "uninstalled:", uninstalled
        print "installed:", installed
        print "selected:", selected
        print "remove:", install_package_list
        print "install:", remove_package_list


        if len(install_package_list) == 0 and len(remove_package_list) == 0:
            return

        result = tkMessageBox.askquestion("Degisiklikleri Kaydet", "Bu islem icin internet baglantisi gerekmektedir. Islem yapilsin mi?", icon='warning')
        if result == 'yes':
            pass
        else:
            return

        self.withdraw()
        configure(install_package_list, remove_package_list)
        self.deiconify()

def main():
    global APT_CACHE

    fp = open(PID_FILE, 'w')
    try:
        fcntl.lockf(fp, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except IOError:
        tkMessageBox.showwarning("HATA", "Bu program veya baska bir paket yoneticisi calisiyor.\n\nDiger program kapandiktan sonra tekrar deneyin.\n")
        exit(1)

    try:
        APT_CACHE = apt.Cache()
    except:
        tkMessageBox.showwarning("HATA", "Baska bir paket yoneticisi calisiyor.\n\nDiger program kapandiktan sonra tekrar deneyin.\n")
        exit(1)

    try:
        print "opening GUI"
        gui = GUI()
        gui.minsize(width=480, height=320)
        # gui.maxsize(width=640, height=500)
        gui.mainloop()
    except:
        # bug varsa sistemi guncelle :)
        system_update()

if __name__ == '__main__':
    main()
