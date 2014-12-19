require 'util'
require 'algs'
require 'set'

include Util


iterations = 1000
outer = 5
inner = 1000
dat = read_args('data/p6.txt', false)
k = dat[0].to_i
dna = dat[2..dat.length]
#p random_motifs(5, dna)

show_elapsed_time('Randomized Motif Search') do 
  #puts pp(randomized_motif_search(dna, k, dna.length, outer, inner))
  #puts pp(randomized_motif_search_o(dna, k, dna.length, iterations))
  #puts write('data/p6_out.txt', pp(randomized_motif_search(dna, k, dna.length, iterations), "\n"))
  puts write('data/p6_out.txt', pp(randomized_motif_search(dna, k, dna.length, outer, inner), "\n"))
end
outs = read_args('data/tmp.txt', false)
p score(outs)

#p build_profile(dat[2..dat.length])
#p score(dat[2..dat.length])
#p freq_table(['G','A','C','C','C'])

