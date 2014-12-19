require 'util'
require 'algs'
require 'set'

include Util

def format sol
  sol.map{|s| s.join('')}.join("\n")
end

infile = 'data/p4.txt'
outfile = 'data/out4.txt'

string = read_lines(infile)[0]


#show_elapsed_time('Longest Repeat'){write(outfile, longest_repeat(string, maxlen))}

#p common_prefix('abcde'.split(''), 'abpqr'.split(''))
#puts format(suffix_tree_edges(string))
#puts all_suffixes(string).map{|x| x.join('')}.join("\n")
#suffix_tree_edges(string)
show_elapsed_time('Suffix Tree Construction'){write(outfile, format(suffix_tree_edges(string)))}
