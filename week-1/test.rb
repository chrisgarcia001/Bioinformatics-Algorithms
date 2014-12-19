require 'algs'
require 'util'

include Util
# ------------ K-mers problem ---------------------
p k_mers('ACGTTGCATGTCGCATGATGCATGAGAGCT',4)
dna = 'CGGAAGCGAGATTCGCGTGGCGTGATTCCGGCGGGCGTGGAGAAGCGAGATTCATTCAAGCCGGGAGGCGTGGCGTGGCGTGGCGTGCGGATTCAAGCCGGCGGGCGTGATTCGAGCGGCGGATTCGAGATTCCGGGCGTGCGGGCGTGAAGCGCGTGGAGGAGGCGTGGCGTGCGGGAGGAGAAGCGAGAAGCCGGATTCAAGCAAGCATTCCGGCGGGAGATTCGCGTGGAGGCGTGGAGGCGTGGAGGCGTGCGGCGGGAGATTCAAGCCGGATTCGCGTGGAGAAGCGAGAAGCGCGTGCGGAAGCGAGGAGGAGAAGCATTCGCGTGATTCCGGGAGATTCAAGCATTCGCGTGCGGCGGGAGATTCAAGCGAGGAGGCGTGAAGCAAGCAAGCAAGCGCGTGGCGTGCGGCGGGAGAAGCAAGCGCGTGATTCGAGCGGGCGTGCGGAAGCGAGCGG'
p k_mers(dna, 12)
# Actual Problem
dna = 'GGGGAAATTTACGATTCCTGACATTACGATTTCTCCACTGGGGAAATTCTCCACTTTACGATTTCTCCACTTTACGATTGGGGAAATCTGGAAATCTCCACTTCTCCACTCTGGAAACCTGACAGGGGAAATTCTCCACTTTACGATTCCTGACACTGGAAATTACGATTTTACGATTGGGGAAATCTGGAAACTGGAAACTGGAAACCTGACACCTGACATTACGATTCCTGACATCTCCACTGGGGAAATTTACGATTTCTCCACTTTACGATTTTACGATTGGGGAAATGGGGAAATCTGGAAACTGGAAACTGGAAATTACGATTCCTGACATCTCCACTCCTGACAGGGGAAATTTACGATTGGGGAAATTCTCCACTTTACGATTTCTCCACTGGGGAAATTCTCCACTCTGGAAACCTGACACCTGACATCTCCACTTTACGATTCTGGAAACCTGACATTACGATTGGGGAAATCTGGAAACTGGAAATCTCCACTCCTGACAGGGGAAATTTACGATTTTACGATTGGGGAAATCTGGAAATCTCCACTGGGGAAATGGGGAAATCCTGACACTGGAAAGGGGAAATGGGGAAATGGGGAAATTCTCCACTCCTGACACTGGAAACTGGAAACTGGAAACTGGAAACTGGAAACTGGAAAGGGGAAATTCTCCACTTCTCCACTGGGGAAATTTACGATTGGGGAAATCCTGACAGGGGAAATTTACGATTCTGGAAACCTGACACCTGACATTACGATTTTACGATTGGGGAAATCCTGACACCTGACAGGGGAAATGGGGAAATCTGGAAAGGGGAAATGGGGAAAT'
puts pp(k_mers(dna, 14))

# ------------ Reverse Complement problem ---------------------
puts reverse_complement('AAAACCCGGT')

# ------------ Pattern Match problem ---------------------
puts pp(pattern_match('GATATATGCATATACTT', 'ATAT'))
write('out.txt', pp(pattern_match(read('in.txt'), 'CTTGATCAT')))

#puts read('tt.txt')
#write('tt.txt', "laquiesha!")

# ------------ Clumps problem --------------------
dna = 'CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA'
p find_clumps 5, 50, 4, dna
#write('out.txt', pp(find_clumps(11, 545, 17, read('in.txt'))))
#show_elapsed_time("Ecoli"){write('out.txt', pp(find_clumps(9, 500, 3, read('ecoli.txt'))))}
#show_elapsed_time("Ecoli"){puts find_clumps(9, 500, 3, read('ecoli.txt')).length.to_s}

# ------------ Minimum Skew problem --------------------
p pp([0] + all_prefix_skews('CATGGGCATCGGCCATACGCC'))
p pp([0] + all_prefix_skews('GAGCCACCGCGATA'))

p pp(min_skew('TAAAGACTGCCGAGAGGCCAACACGAGTGCTAGAACGAGGGGCGTAAACGCGGGTCCGAT').map{|x| x + 1})
#write('out.txt', min_skew(read('in.txt')).map{|x| x + 1})

# ------------ Approximate Match problem --------------------
p pp(approximate_match('ATTCTGGA', 'CGCCCGAATCCAGAACGCATTCCCATATTTCGGGACCACTGGCCTCCACGGTACGGACGTCAATCAAAT', 3))
#write('out.txt', approximate_match('AGGTTGCGC', read('in.txt'), 4))
#p pp(approximate_match('AGGTTGCGC', read('in.txt'), 4))


#------------- Frequent Words with Mismatches problem ---------
#puts pp(all_sequences([:a,:b,:c], 3))
#p all_sequences([:a,:b,:c], 3)
#show_elapsed_time("Sequences"){all_sequences(['A','C', 'G', 'T'], 10); nil}
#p k_mer_freqs('ACGTTGCATGTCGCATGATGCATGAGAGCT', 4)
#show_elapsed_time('kmers'){p k_mer_freqs(read('in.txt'), 10).length}
#p ncombs(2,6,3)
#p ncombs(2,6,0)
#show_elapsed_time('ncombs'){p ncombs(1,10,3).length * 318 * (4**3)}
#puts pp(positional_mismatches('AAAAAAA',[1,3]))
#puts pp(positional_mismatches('AAAAAAA',[]))
#puts pp(frequent_words_with_mismatches('ACGTTGCATGTCGCATGATGCATGAGAGCT', 4, 1))
#args = read_args('in.txt')
#puts args
#show_elapsed_time('Frequent Words with Mismatches') {write('out.txt', frequent_words_with_mismatches(read('in.txt'), 10, 2))}
#show_elapsed_time('Frequent Words with Mismatches') {write('out.txt', frequent_words_with_mismatches(args[0], args[1].to_i, args[2].to_i))}
#puts pp(frequent_words_with_mismatches_reverse_comps('ACGTTGCATGTCGCATGATGCATGAGAGCT', 4, 1))
args = read_args('in.txt')
show_elapsed_time('Frequent Words with Mismatches/Rev. Complements') {write('out.txt', frequent_words_with_mismatches_reverse_comps(args[0], args[1].to_i, args[2].to_i))}


