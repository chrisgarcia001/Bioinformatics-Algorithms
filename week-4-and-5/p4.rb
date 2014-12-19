require 'util'
require 'algs'
require 'set'

include Util

def sjoin
  Proc.new{|x,y| x + ' -> ' + y}
end

dat = read_args('data/p4.txt', false)
#p debrujin_kmers(dat)
write('data/out.txt', debrujin_kmers(dat).join("\n"))
