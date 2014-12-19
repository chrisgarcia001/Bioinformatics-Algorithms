require 'util'
require 'algs'
require 'set'

include Util

def format sol
  sol.map{|s| s.join('')}.join("\n")
end

infile = 'data/p8.txt'
outfile = 'data/out8.txt'

string = read_lines(infile)[0]

#puts format(suffix_tree_edges(string))
show_elapsed_time('Suffix Tree Construction'){write(outfile, format(suffix_tree_edges(string)))}
