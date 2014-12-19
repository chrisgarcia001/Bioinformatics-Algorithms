require 'util'
require 'algs'
require 'set'

include Util

p pp(composition('TATGGGGTGC', 3))
dat = read_args('data/p1.txt', false)
write('data/out1.txt', composition(dat[1], dat[0].to_i).join("\n"))
