require 'util'
require 'algs'
require 'set'

include Util

def writef text, outfile
  show_elapsed_time('Burrows-Wheeler Transform') do
    data = bwt(text)
    write(outfile, data)
  end  
end

infile = 'data/p2.txt'
outfile = 'data/out2.txt'

#p sym_counts('abracadabra')
#p enum('b', 5, 15)
#p enum_syms('abracadabra')
#p bwt('TTCCTAACG$A')

text= read_lines(infile)[0]
writef(text, outfile)


