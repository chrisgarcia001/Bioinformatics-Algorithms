require 'util'
require 'algs'
require 'set'

include Util

#p dp_change(40, [50,25,20,10,5,1])

money = 19237
coins = [5,3,1]

p dp_change(money, coins)
