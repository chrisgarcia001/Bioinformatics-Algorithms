require 'util'
require 'algs'
require 'set'

include Util

rna_codon_table = {}
dna_codon_table = {}
read_csv('dna_codon_table.csv').each do |pr| 
  dna_codon_table[pr[0]] = pr[1]
  rna_codon_table[dna_to_rna(pr[0])] = pr[1]
end
p rna_codon_table['AUU']

# --- Protein translation
puts protein_translation('AUGGCCAUGGCGCCCAGAACUGAGAUCAAUAGUACCCGUAUUAACGGGUGA', rna_codon_table)
#write('out.txt', protein_translation(read('in.txt'), rna_codon_table))

# --- Peptide encoding
p nchunk('ATGGCCATGGCCCCCAGAACTGAGATCAATAGTACCCGTATTAACGGGTGA', 3)
p peptide_encoding('ATGGCCATGGCCCCCAGAACTGAGATCAATAGTACCCGTATTAACGGGTGA', 'MA', dna_codon_table)
p peptide_encoding('GGCCAT', 'MA', dna_codon_table)

#args = read_args('in.txt', true)
#p args
#args = read_args('in.txt', false)
#p args
#write('out.txt', pp(peptide_encoding(args[0], args[1], dna_codon_table)))
#puts peptide_encoding(args[0], args[1], dna_codon_table).length.to_s
#show_elapsed_time('B. Brevis') {puts peptide_encoding(read('b_brevis.txt', true), 'VKLFPWFNQY', dna_codon_table).length.to_s}

# --- Generating theoretical spectrum
p powerseq(['a','b','c','d'])
mass_spec_table = {}
read_csv('mass_spec.txt', ' ').each do |pr| 
  mass_spec_table[pr[0]] = pr[1].to_i
end
#p mass_spec_table
puts pp(cyclospectrum('LEQN', mass_spec_table))
puts ''
#puts pp(cyclospectrum('IAQMLFYCKVATN', mass_spec_table))
#a1 = cyclospectrum('IAQMLFYCKVATN', mass_spec_table)
#a2 = read_args('tmp.txt')
#p a1 - a2.map{|x| x.to_i}
#p a2.map{|x| x.to_i} - a1
#p all_rotations(['a', 'b', 'c'])
#p all_rotations(['a'])
#pep = 'FPSYCSYNFEANK'
#show_elapsed_time('Theoretical Spec.'){write('out.txt', pp(cyclospectrum(pep, mass_spec_table)))}

# --- Cyclopeptide sequencing problem
#puts pp(cyclospectrum([186, 128, 113]))
#p freq_table([1,1,1,1,2,2,4,5,5,5])
aminos = mass_spec_table.values.map{|a| a.to_i}
#p aminos
spec = [0, 113, 128, 186, 241, 299, 314, 427]
#spec = read_args('t2.txt').map{|m| m.to_i}
#p cyclopeptide_seq_2(spec, aminos, 500)
#p pp(cyclopeptide_seq(spec, aminos))
#p pp(cyclopeptide_seq_0(spec, aminos))
#p read_args('in.txt', true)
#a1 = []
spec = read_args('in.txt', true).map{|m| m.to_i}
#show_elapsed_time('Cyclopeptide Sequencing') {p cyclopeptide_seq(spec, aminos)}
#a1 = cyclopeptide_seq(read_args('in.txt', true).map{|a| a.to_i}, aminos)
#a2 = read_args('tmp.txt')
#p a1 - a2.map{|x| x.to_i}
#p a2.map{|x| x.to_i} - a1
data = nil
show_elapsed_time('Cyclopeptide Sequencing') do 
  data = pp(cyclopeptide_seq(spec, aminos))
end
write('out.txt', data)

# --- Leaderboard cyclopeptide sequencing problem
board = Leaderboard.new(2)
board.add 'a',4 
board.add 'e', 2
board.add 'b',6
board.add 'c', 4
board.add 'd', 4
board.add 'f', 8

#puts board.elements

pep = [0, 99, 113, 114, 128, 227, 257, 299, 355, 356, 370, 371, 484]
spec = [0, 113, 114, 128, 227, 257, 355, 356, 370, 371, 484]
puts score(pep, spec)
spec = [0, 71, 113, 129, 147, 200, 218, 260, 313, 331, 347, 389, 460]
n = 10
#p total_mass([1,2,3])
data = nil
#show_elapsed_time('First Go') do
#  data = leaderboard_cyclopeptide_seq(spec, aminos, n)
#end
#puts data
#puts leaderboard_cyclopeptide_seq(spec, aminos, n, false)
#args = read_args('in.txt', true).map{|a| a.to_i}
#spec = args[1..args.length]
#n = args[0]
#data = nil
#show_elapsed_time('Leaderboard Sequencing') do 
#  data = leaderboard_cyclopeptide_seq(spec, aminos, n)
#end
#puts data
#write('out.txt', data)

# --- Spectral convolution problem
#puts pp(spectral_convolution([0,137,186,323]))
#spec = read_args('in.txt', true).map{|a| a.to_i}
#p spec
#show_elapsed_time('Spectral Convolution') do 
#  data = pp(spectral_convolution(spec))
#end
#write('out.txt', data)

# --- Convolution cyclopeptide sequencing problem
#p most_frequent([30,40,91,91,205,121,67,58,58,58,58,58,121,0],2)
#args = read_args('t2.txt').map{|x| x.to_i}
#m = args[0]
#n = args[1]
#spec = args[2..args.length]
#puts conv_seq(m, n, spec)
#args = read_args('in.txt').map{|x| x.to_i}
#m = args[0]
#n = args[1]
#spec = args[2..args.length]
#data = nil
#show_elapsed_time('Convolution Cyclopeptide Sequencing') do 
#  data = conv_seq(m, n, spec)
#end
#write('out.txt', data)


