require 'util'
require 'algs'
require 'set'

include Util

def print sol
  show_elapsed_time('Middle Edge') do
    puts '(' + sol[0].map{|x| x.to_s}.join(', ') + ') ('+ sol[1].map{|x| x.to_s}.join(', ') + ')'
  end
end


score = score_matrix('data/blosum62.txt')
#v = 'PLEASANTLY'
#w = 'MEASNLY'

infile = 'data/p5.txt'
v, w = read_lines(infile)
print middle_edge(v.split(''), w.split(''), score, 5)