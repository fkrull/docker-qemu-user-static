#!/usr/bin/python3
import os
import shutil
import sys

def copy_binary(item, usrbin_dir, binaries_dir):
    binary = os.path.join(usrbin_dir, '%s-static' % item)
    print('copying %s ...' % binary)
    shutil.copy2(binary, binaries_dir)

def copy_binaries(formats_dir, usrbin_dir, binaries_dir):
    for item in os.listdir(formats_dir):
        copy_binary(item, usrbin_dir, binaries_dir)

def main():
    formats_dir = sys.argv[1]
    usrbin_dir = sys.argv[2]
    binaries_dir = sys.argv[3]
    copy_binaries(formats_dir, usrbin_dir, binaries_dir)

if __name__ == '__main__':
    main()
