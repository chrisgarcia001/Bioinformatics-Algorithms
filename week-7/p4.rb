require 'util'
require 'algs'
require 'set'

include Util

def print sol
  puts sol[:s1].join('')
  puts sol[:s2].join('')
  puts 'Weight: ' + sol[:w].to_s
end

def writef v, w, score, outfile
  show_elapsed_time('Overlap Alignment') do
    sol = affine_gap_align(v.split(''), w.split(''), score, 11, 1)
    data = [sol[:w].to_s, sol[:s1].join(''), sol[:s2].join('')].join("\n")
    write(outfile, data)
  end  
end

score = score_matrix('data/blosum62.txt')
#p score['E']['A']
#p score['E']['Y']
v = 'PRTEINS'
w = 'PRTWPSEIN'
infile = 'data/p4.txt'
outfile = 'data/out4.txt'
v, w = read_lines(infile)
print affine_gap_align(v.split(''), w.split(''), score, 11, 1)
writef(v, w, score, outfile)

