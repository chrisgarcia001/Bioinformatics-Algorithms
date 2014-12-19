require 'util'
require 'algs'
require 'set'

include Util

def parse_seq string
  string[1..(string.length - 1)].split(')(').map{|seq| seq.split(' ').map{|v| v.to_i}}
end

g = {1=>[2],2=>[3],3=>[1],4=>[5],5=>[6],6=>[4]}
#p cycle_count(g)
#p get_strands([[1,2,3],4,5,[[6,7], [8,9]]])
 #(+1 −3 −6 −5)(+2 −4)
#p breakpoint_graph([1,2,3,4,5,6],[[1,-3,-6,-5],[2,-4]])
#p two_break_dist([1,2,3,4,5,6],[[1,-3,-6,-5],[2,-4]])
#p parse_seq('(+1 +2 +3 +4 +5 +6)')
#p parse_seq('(+1 -3 -6 -5)(+2 -4)')

infile = 'data/p3.txt'
s1, s2 = read_lines(infile)
p two_break_dist(parse_seq(s1), parse_seq(s2))
write('data/out3.txt', two_break_dist(parse_seq(s1), parse_seq(s2)))
