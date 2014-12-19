require 'util'
require 'algs'
require 'set'

include Util

#smp = Sampler.new [3,2,4,18,1] #[1,1,1,1,1,1,1,1,1,1] #
#p smp.get_val(0.99)
#1.upto(10){p smp.get_random}

dat = read_args('data/p7.txt', false)
k = dat[0].to_i
n = dat[2].to_i
mult = 15
p n
dna = dat[3..dat.length]
#p random_motifs(5, dna)

show_elapsed_time('Randomized Motif Search') do 
  #puts pp(local_search(dna, k, mult * n))
  #puts write('data/p7_out.txt', pp(local_search(dna, k, mult * n), "\n"))
  sol = meta(mult){gibbs_sampler(dna, k, dna.length, n)}
  #puts pp(sol)
  puts write('data/p7_out.txt', pp(sol, "\n"))
  p score(sol)
  #puts write('data/p7_out.txt', pp(gibbs_sampler(dna, k, dna.length, n), "\n"))
end
outs = read_args('data/tmp.txt', false)
p score(outs)