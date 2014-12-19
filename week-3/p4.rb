require 'util'
require 'algs'
require 'set'

include Util



dat = read_args('data/pp4.txt', false)
k = dat[0].to_i
dna = dat[2..dat.length]
#a1 = greedy_motif_search(dna, k, dna.length)
#gold = read_args('data/gold.txt', false)
#compare(a1, gold)
show_elapsed_time('Profile Most Probable K-Mer') do 
  puts write('data/p4_out.txt', pp(greedy_motif_search(dna, k, dna.length), "\n"))
  #puts pp(greedy_motif_search(dna, k, dna.length))
end

#p build_profile(dat[2..dat.length])
#p score(dat[2..dat.length])
#p freq_table(['G','A','C','C','C'])

