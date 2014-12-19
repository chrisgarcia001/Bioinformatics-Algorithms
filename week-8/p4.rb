require 'util'
require 'algs'
require 'set'

include Util

def format_output arr
  arr.map{|pair| "(#{pair.join(', ')})"}.join("\n")
end

def writef k, s1, s2, outfile
  show_elapsed_time('Shared Kmers') do
    write(outfile, format_output(shared_kmers(k.to_i, s1, s2)))
  end
end

#p reverse_complement('AAAGGG')
#k = 3
#s1 = 'AAACTCATC'
#s2 = 'TTTCAAATC'
#p shared_kmers(k, s1, s2)

infile = 'data/p4.txt'
outfile = 'data/out4.txt'
k, s1, s2 = read_lines(infile)
#puts format_output(shared_kmers(k.to_i, s1, s2))
#write(outfile, format_output(shared_kmers(k.to_i, s1, s2)))
writef(k, s1, s2, outfile)
