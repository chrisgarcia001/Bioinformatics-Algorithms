require 'util'
require 'algs'
require 'set'

include Util

def writef input_string, outfile
  show_elapsed_time('Greedy Sorting') do
    sol = greedy_sort(format_input(input_string))
    data = format_solution(sol)
    write(outfile, data)
  end  
end

infile = 'data/p1.txt'
outfile = 'data/out1.txt'

strings = read_lines(infile)
trie = TrieNode.new
strings.each{|s| trie.add_next(s)}
trie.enumerate
#puts trie.to_adj_list_str
show_elapsed_time('Trie Construction'){write(outfile, trie.to_adj_list_str)}


