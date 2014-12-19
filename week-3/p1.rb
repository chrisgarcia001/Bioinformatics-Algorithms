require 'util'
require 'algs'
require 'set'

include Util

#p ncombs(1,4,2)
#p all_mismatches('-----',2)
#p pattern_match('abcabcabc', 'bc')
#p unique_kmers(',abcaaaababsas', 3)
#p approximate_match('abcdabefbcd', 'abc', 1)

dat = read_args('data/p1.txt', false)
show_elapsed_time('Motif Enum') { write('data/p1_out.txt', pp(motif_enum(dat[0].to_i, dat[1].to_i, dat[2..dat.length]).to_a)) }


