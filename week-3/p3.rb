require 'util'
require 'algs'
require 'set'

include Util

dat = read_csv('data/p3.txt', ' ')
profile = read_profile(dat[2..dat.length])
#p profile_prob('GGGAG', prof)
show_elapsed_time('Profile Most Probable K-Mer') do 
  puts profile_most_probable_kmer(dat[0][0], dat[1][0].to_i, profile)
end
