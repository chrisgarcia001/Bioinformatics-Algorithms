require 'util'
require 'algs'
require 'set'

include Util

#p cycle_join([1,2,3,4,5],[3,9,12,3])
#p cycle_join([1,2,3,4,5],[6,7,8,6])

dat = read_args('data/p10.txt', false)
d2 = read_args('data/t3.txt', false)
p contigs(d2)
#graph = parse_graph(dat)
#p euler_path(parse_graph(dat))
#puts reconstruct_read_pairs(pairs, d)
#p add_if_compatible('ABC|DEF', [], 0, 4)
show_elapsed_time('Contigs') {write('data/out.txt', contigs(dat).sort)}
#a1 = contigs(dat)
#a2 = read_args('data/out_compare.txt', false)
#compare(a1, a2)


