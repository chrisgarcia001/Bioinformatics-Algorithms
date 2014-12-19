require 'util'
require 'algs'
require 'set'

include Util


dat = read_args('data/p6.txt', false)
k = dat[0].to_i
n = 1000
mult = 30
#p n
dna = dat[2..dat.length]
#p random_motifs(5, dna)

show_elapsed_time('Randomized Motif Search') do 
  #puts pp(local_search(dna, k, mult * n))
  #puts write('data/p7_out.txt', pp(local_search(dna, k, mult * n), "\n"))
  sol = meta(mult){gibbs_sampler(dna, k, dna.length, n)}
  #puts pp(sol)
  puts write('data/p6_out.txt', pp(sol, "\n"))
  p score(sol)
  #puts write('data/p7_out.txt', pp(gibbs_sampler(dna, k, dna.length, n), "\n"))
end
outs = read_args('data/tmp.txt', false)
p score(outs)