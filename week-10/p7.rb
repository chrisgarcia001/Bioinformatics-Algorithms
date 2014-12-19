require 'util'
require 'algs'
require 'set'

include Util

def format sol
  #sol.join(' ')
  sol.flatten.map{|x| x.to_s}.join(' ')
end

def writef text, patterns, d, outfile
  show_elapsed_time('Multiple Approximate Pattern Matching') do
    sol = multiple_approx_pattern_matches(text, patterns, d)
    data = format(sol)
    write(outfile, data)
  end  
end

def avg nums
  total = nums.reduce{|x,y| x+y}.to_f
  total/nums.length.to_f
end

#p matches_within('abadddddbcwwwawcqq'.split(''), 'abc'.split(''), 1)
infile = 'data/p7.txt'
outfile = 'data/out7.txt'
data = read_lines(infile)
text = data[0]
patterns = data[1].split(' ')
d = data[2].to_i
#p format(multiple_approx_pattern_matches(text, patterns, d))
writef text, patterns, d, outfile

k_max = patterns.map{|x| x.length}.max
k_min = patterns.map{|x| x.length}.min
puts 'Min/Max k: ' + [k_min, k_max].inspect
puts 'Text Length: ' + text.length.to_s
puts 'Num Patterns: ' + patterns.length.to_s
kmers = indexed_kmers(k_max, text)
puts 'Average kmer occurrences: ' + avg(kmers.values.map{|x| x.length}).to_s
puts 'Average pattern occurrences: ' + avg(unique_counts(patterns).values).to_s
