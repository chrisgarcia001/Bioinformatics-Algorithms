require 'util'
require 'algs'
require 'set'

include Util

infile = 'data/p2.txt'

data = read_lines(infile)
n = data[0].to_i
m = data[1].to_i
split = data.index('-')
downdat = data[2..(split - 1)]
rightdat = data[(split + 1)..data.length]
down, right = [downdat, rightdat].map{|mat| mat.map{|r| r.split(' ').map{|v| v.to_i}}}
down = [Array.new(m+1, 0)] + down
0.upto(right.length - 1){|i| right[i] = [0] + right[i]}
#p n
#p m
#p down
#p right
p manhattan_tourist(n, m,  down, right)
