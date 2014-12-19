require 'util'
require 'algs'
require 'set'

include Util

def print sol
  puts sol[:s1].join('')
  puts sol[:s2].join('')
  puts sol[:s3].join('')
  puts 'Weight: ' + sol[:w].to_s
end

def writef v, w, x, outfile
  show_elapsed_time('Overlap Alignment') do
    sol = mlcs(v.split(''), w.split(''), x.split(''))
    data = [sol[:w].to_s, sol[:s1].join(''), sol[:s2].join(''), sol[:s3].join('')].join("\n")
    write(outfile, data)
  end  
end

#p build_3d_matrix(2,2,3,'-')
v = 'ATATCCG'
w = 'TCCGA'
x = 'ATGTACTG'
#print mlcs(v.split(''), w.split(''), x.split(''))

infile = 'data/p7.txt'
outfile = 'data/out7.txt'
v, w, x = read_lines(infile)
print mlcs(v.split(''), w.split(''), x.split(''))
writef(v, w, x, outfile)
