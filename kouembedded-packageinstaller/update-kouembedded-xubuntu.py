#!/usr/bin/python
# -*- coding: utf-8 -*-

UPDATE_LIST = [
    "v20160217"
]

import subprocess

def get_current_version():
    try:
        version = open("/var/lib/kouembedded-xubuntu/version").read().replace('\n', '')
    except:
        version = ""
    return version

def bash_run(script_path):
    cmd = "bash %s" % script_path
    p = subprocess.Popen(cmd, shell=True)
    p.communicate()
    return p.returncode


def update(current_version):
    try:
        next_update_index = UPDATE_LIST.index(current_version) + 1
    except:
        next_update_index = 0

    for i in range(next_update_index, len(UPDATE_LIST)):
        # script_path = "OS-updates/%s.sh" % UPDATE_LIST[i]
        script_path = "/usr/lib/kouembedded-packageinstaller/OS-updates/%s.sh" % UPDATE_LIST[i]
        exit_code = bash_run(script_path)

        if exit_code != 0 or get_current_version() != UPDATE_LIST[i]:
            print "update error"
            print "exit_code: %s, current_version: %s" % (exit_code, get_current_version())

def main():
    current_version = get_current_version()

    if current_version != UPDATE_LIST[-1]:
        print "OS version : %s" % current_version
        print "last update : %s" % UPDATE_LIST[-1]
        update(current_version)
    else:
        print "latest OS version installed"

if __name__ == '__main__':
    main()
