require 'util'
require 'algs'
require 'set'

include Util

s1 = 'PLEASANTLY'
s2 = 'MEANLY'

#s1 = 'TGCATAT'
#s2 = 'ATCCGAT'

infile = 'data/p1.txt'

s1, s2 = read_lines(infile)
p edit_distance(s1.split(''), s2.split(''))
