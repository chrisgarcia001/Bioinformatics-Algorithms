require 'util'
require 'algs'
require 'set'

include Util

#p cycle_join([1,2,3,4,5],[3,9,12,3])
#p cycle_join([1,2,3,4,5],[6,7,8,6])

dat = read_lines('data/p5.txt')
graph = parse_graph(dat)
#p dat
#p graph
#p merge_cycles([[1,2,3,1],[6,7,8,9,10,6],[2,6,15,2],[9,16,18,9]])
#puts euler_cycle(parse_graph(dat)).join('->')
#p euler_cycle(parse_graph(dat))
#write('data/out.txt', euler_cycle(parse_graph(dat)).map{|x| x.inspect}.join("\n"))
#p debrujin_kmers(dat)
show_elapsed_time('Euler Cycle') do
  write('data/out.txt', euler_cycle(parse_graph(dat)).join('->'))
end

