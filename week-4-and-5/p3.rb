require 'util'
require 'algs'
require 'set'

include Util

def sjoin
  Proc.new{|x,y| x + ' -> ' + y}
end

dat = read_args('data/p3.txt', false)
k = dat[0].to_i
text = dat[1]
#p debrujin(k, text)
write('data/out2.txt', debrujin(k, text).join("\n"))
