require 'util'
require 'algs'
require 'set'

include Util

infile = 'data/p3.txt'
outfile = 'data/out3.txt'

string = read_lines(infile)[0]
maxlen = 100
#puts longest_repeat(string, maxlen)
show_elapsed_time('Longest Repeat'){write(outfile, longest_repeat(string, maxlen))}

#puts longest_prefix('abcd', 'abeds').join('')
#q = all_suffixes(string)
#p all_suffixes('abcde').map{|x| x.join('')}
