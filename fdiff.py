#!/usr/bin/env python

import re
import sys

st = sys.argv[1].split('\n')
tracked = sys.argv[2].split('\n')
untracked = sys.argv[3].split('\n')
st_parts = [re.split(r'(.*\[m\s+)', s)[1:] for s in st]
st_longest = max([len(p[1]) for p in st_parts])

if tracked == ['']:
    tracked = []

split_tracked = []
pad_tracked = 0
if tracked:
    split_tracked = [t.split(' ')[1] for t in tracked]
    pad_tracked = max(len(t) for t in split_tracked)

pad_untracked = max(len(u) for u in untracked)
pad_counts = max(pad_tracked, pad_untracked)
diff_stats = split_tracked + [u or '\x1b[33m{}\x1b[m'.format('?' * pad_counts) for u in untracked]
diff_lines = [' '.join(t.split(' ')[2:]) for t in tracked] + ['\x1b[33m+~\x1b[m' for u in untracked]
pad_st = ['{:<{}} | {:>{}} {}'.format(s, (st_longest + len(st_parts[i][0])), diff_stats[i], pad_counts, diff_lines[i]) for i, s in enumerate(st)]
print('\n'.join(pad_st))
sys.exit(0)
