require 'util'
require 'algs'
require 'set'

include Util

infile = 'data/p5.txt'
outfile = 'data/out5.txt'

lines = read_lines(infile)

s1 = lines[0]
s2 = lines[1]
#p common_kmers(3, 'abcde','nmnmabcjkjkcdef')
#puts longest_shared_substrings(s1, s2).to_a#.join('')
#show_elapsed_time('Longest Shared Substring'){write(outfile, longest_shared_substring(s1, s2).join(''))}
show_elapsed_time('Longest Shared Substring'){write(outfile, longest_shared_substrings(s1, s2).to_a.first)}
