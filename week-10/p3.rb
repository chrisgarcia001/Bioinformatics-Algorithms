require 'util'
require 'algs'
require 'set'

include Util


def writef text, patterns, outfile
  show_elapsed_time('Burrows-Wheeler Matching') do
    data = bwt_match(text, patterns).map{|x| x.to_s}.join(' ')
    write(outfile, data)
  end  
end

infile = 'data/p3.txt'
outfile = 'data/out3.txt'

data = read_lines(infile)
text = data[0]
patterns = data[1].split(' ')

#puts bwt_match(text, patterns).map{|x| x.to_s}.join(' ')

writef(text, patterns, outfile)

