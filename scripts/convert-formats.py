#!/usr/bin/python3
import os
import sys

class Binfmt:
    TYPE_MAGIC = 1
    TYPE_EXT = 2

    def __init__(self, name, package, type, offset, magic, mask, interpreter):
        self.name = name
        self.package = package
        self.type = type
        self.offset = offset
        self.magic = magic
        self.mask = mask
        self.interpreter = interpreter
        self.flags = 'OCF'

    @classmethod
    def from_lines(cls, name, lines):
        return cls(
            name=name,
            package=lines[0],
            type=cls.TYPE_MAGIC if lines[1] == 'magic' else cls.TYPE_EXT,
            offset=int(lines[2]),
            magic=lines[3],
            mask=lines[4],
            interpreter=lines[5]
        )

    def __str__(self):
        return (':%(name)s:%(type)s:%(offset)s:%(magic)s:%(mask)s:'
                '%(interpreter)s:%(flags)s') % {
                    'name': self.name,
                    'type': 'M' if self.type == self.TYPE_MAGIC else 'E',
                    'offset': self.offset,
                    'magic': self.magic,
                    'mask': self.mask,
                    'interpreter': self.interpreter,
                    'flags': self.flags,
                }

def get_binfmt(name, lines):
    return Binfmt.from_lines(name, [line.strip() for line in lines])

def main():
    input_dir = sys.argv[1]
    output_dir = sys.argv[2]
    for fname in os.listdir(input_dir):
        input_file = os.path.join(input_dir, fname)
        print('converting %s ...' % fname)
        with open(input_file, 'r') as fin:
            binfmt = get_binfmt(fname, fin)
        with open(os.path.join(output_dir, binfmt.name), 'w') as fout:
            fout.write(str(binfmt))

if __name__ == '__main__':
    main()
