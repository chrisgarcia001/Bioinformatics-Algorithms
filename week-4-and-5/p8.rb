require 'util'
require 'algs'
require 'set'

include Util

#p all_bin_strings(4)
#puts univ_circular_string(4, true)

n = 16

show_elapsed_time('k-Universal Curcular string') do
  write('data/out.txt', univ_circular_string(n, true))
end

