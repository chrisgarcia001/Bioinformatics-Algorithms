require 'util'
require 'algs'
require 'set'

include Util

infile = 'data/p7.txt'
outfile = 'data/out7.txt'

lines = read_lines(infile)

text = lines[0]
#puts suffix_array(text).map{|i| i.to_s}.join(', ')
show_elapsed_time('Suffix Array'){write(outfile, suffix_array(text).map{|i| i.to_s}.join(', '))}