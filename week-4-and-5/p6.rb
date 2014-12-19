require 'util'
require 'algs'
require 'set'

include Util

#p cycle_join([1,2,3,4,5],[3,9,12,3])
#p cycle_join([1,2,3,4,5],[6,7,8,6])

dat = read_lines('data/p6.txt')
graph = parse_graph(dat)
#p dat
#p graph
#p merge_cycles([[1,2,3,1],[6,7,8,9,10,6],[2,6,15,2],[9,16,18,9]])
#puts euler_path(parse_graph(dat)).join('->')
#p euler_path(parse_graph(dat)).length

show_elapsed_time('Euler Path') do
  write('data/out.txt', euler_path(parse_graph(dat)).join('->'))
end

