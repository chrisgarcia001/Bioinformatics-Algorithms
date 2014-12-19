require 'util'
require 'algs'
require 'set'

include Util

def score filename
  lines = read_lines(filename)
  lines[0] = '- ' + lines[0]
  matrix = {}
  col_heads = lines[0].split(' ')
  1.upto(lines.length - 1) do |i|
    line = lines[i].split(' ')
    row = {}
    1.upto(line.length - 1) do |j|
      row[col_heads[j]] = line[j].to_i 
    end
    matrix[line[0]] = row
  end
  matrix
end

def print sol
  puts sol[:s1].join('')
  puts sol[:s2].join('')
  puts 'Weight: ' + sol[:w].to_s
end

def writef s1, s2, score_matrix, sigma, outfile
  show_elapsed_time('Local Alignment') do
    sol = fast_lalign(s1.split(''), s2.split(''), score_matrix, sigma)
    data = [sol[:w].to_s, sol[:s1].join(''), sol[:s2].join('')].join("\n")
    write(outfile, data)
  end  
end

# ----------------- MAIN ----------------------------------------
score_matrix = score('data/pam250.txt')
infile = 'data/p6.txt'
outfile = 'data/out6.txt'
sigma = 5
#s1 = 'MEANLY'
#s2 = 'PENALTY'

#s1 = 'MEANLYPRTEINSTRING'
#s2 = 'PLEASANTLYEINSTEIN'

#print fast_lalign(s1.split(''), s2.split(''), score_matrix, sigma)

#print lalign(s1.split(''), s2.split(''), score_matrix, sigma)
s1, s2 = read_lines(infile)
writef(s1, s2, score_matrix, sigma, outfile)


