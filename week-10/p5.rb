require 'util'
require 'algs'
require 'set'

include Util

def format sol
  sol.map{|v| v.map{|x| x.to_s}.join(',')}.join("\n")
end

def writef text, k, outfile
  show_elapsed_time('Partial Suffix Array') do
    data = format(partial_suffix_array(text, k))
    write(outfile, data)
  end  
end

infile = 'data/p5.txt'
outfile = 'data/out5.txt'

#text = 'PANAMABANANAS$'
#k = 5

lines = read_lines(infile)
text = lines[0]
k = lines[1].to_i

#puts format(partial_suffix_array(text, k))
writef(text, k, outfile)


