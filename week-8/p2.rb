require 'util'
require 'algs'
require 'set'

include Util

def format_input str
  str[1..(str.length - 2)].split(' ').map{|x| x.to_i}
end

infile = 'data/p2.txt'

input_string = read_lines(infile)[0]
#p format_input(input_string)
puts breakpoint_count(format_input(input_string)).to_s


