require 'util'
require 'algs'
require 'set'

include Util

#p cycle_join([1,2,3,4,5],[3,9,12,3])
#p cycle_join([1,2,3,4,5],[6,7,8,6])

dat = read_lines('data/p7.txt')
graph = parse_graph(dat)
#p euler_path(parse_graph(dat))
#puts overlap_join(euler_path(parse_graph(dat)))

show_elapsed_time('String Reconstruction') do
  #write('data/out.txt', overlap_join(euler_path(parse_graph(dat))))
  write('data/out.txt', string_reconstruct(parse_graph(dat)))
end

