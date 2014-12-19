require 'util'
require 'algs'
require 'set'

include Util

#p cycle_join([1,2,3,4,5],[3,9,12,3])
#p cycle_join([1,2,3,4,5],[6,7,8,6])

filename = 'data/t1.txt'
dat = read_args(filename, false)
d = dat[0].to_i
pairs = dat[1..dat.length]
#p paired_debrujin_edges(pairs, false)
#puts ''
#p paired_debrujin_edges(pairs, true)


#p reconstruct_read_pairs(pairs, d)

##d=1 -> abc|efg, bcd|fgh, cde|ghi => abcdefghi
a1 = ['a','b','c','d','e','f']
a2 = ['e','f','g','h','i','j']

#p rp_compatible?([['f','g'],['j','k']],1,5, a1 + [nil] + a2)
#p rp_compatible?([['f','k'],['j','k']],1,5, a1 + a2)

show_elapsed_time('Read Pairs String Reconstruction') {write('data/out.txt', reconstruct_read_pairs(pairs, d))}
#p pairs.map{|x| x.split("|")}.flatten
#show_elapsed_time('Read Pairs String Reconstruction') {write('data/out.txt', recons_read_pairs(pairs, d))}
outc = read('data/out_compare.txt').split('')
out = read('data/out.txt').split('')
diff_comp(out, outc)
compare(out, outc)
p [outc.length, out.length]
