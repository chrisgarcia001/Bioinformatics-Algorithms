require 'util'
require 'algs'
require 'set'

include Util

#p all_strings(3)
p hamming('abcd', 'bccd')
p shortest_hamming('abc','bdedawcbe')

dat = read_args('data/p2.txt', false)
show_elapsed_time('Median String') { p median_string(dat[1..dat.length], dat[0].to_i) }
