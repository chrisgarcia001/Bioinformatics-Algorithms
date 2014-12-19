require 'util'
require 'algs'
require 'set'

include Util

def writef text, outfile
  show_elapsed_time('Burrows-Wheeler Construction') do
    data = borrows_wheeler_construction(text)
    write(outfile, data)
  end  
end

infile = 'data/p1.txt'
outfile = 'data/out1.txt'

#text = 'GCGTGCCTGGTCA$'
text= read_lines(infile)[0]
#p rotate('abcd'.split(''))

#puts borrows_wheeler_construction(text)
writef(text, outfile)


