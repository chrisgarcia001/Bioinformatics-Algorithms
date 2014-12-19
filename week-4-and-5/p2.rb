require 'util'
require 'algs'
require 'set'

include Util

def sjoin
  Proc.new{|x,y| x + ' -> ' + y}
end

dat = read_args('data/p2.txt', false)
#p overlap_graph(dat){|x,y| x + ' -> ' + y}
write('data/out2.txt', overlap_graph(dat){|x,y| x + ' -> ' + y}.join("\n"))
