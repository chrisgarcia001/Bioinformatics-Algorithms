require 'util'
require 'algs'
require 'set'

include Util

def format_sol sol
  #sol.map{|pos| pos.map{|x| x.to_s}.join(' ')}.join("\n")
  sol.flatten.join(' ')
end

def writef strings, outfile
  show_elapsed_time('Multiple Pattern Matching') do
    sol = bf_multi_pattern_match(strings[0], strings[1..strings.length])
    data = format_sol(sol)
    write(outfile, data)
  end  
end

infile = 'data/p6.txt'
outfile = 'data/out6.txt'

strings = read_lines(infile)
#puts format_sol(bf_multi_pattern_match(strings[0], strings[1..strings.length]))
writef strings, outfile