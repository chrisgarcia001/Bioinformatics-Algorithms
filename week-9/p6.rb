require 'util'
require 'algs'
require 'set'

include Util

infile = 'data/p6.txt'
outfile = 'data/out6.txt'

lines = read_lines(infile)

s1 = lines[0]
s2 = lines[1]
#p common_kmers(3, 'abcde','nmnmabcjkjkcdef')
#puts shortest_nonshared_substrings(s1, s2).to_a
show_elapsed_time('Shortest Nonshared Substring'){write(outfile, shortest_nonshared_substrings(s1, s2).to_a.first)}
