require 'util'
require 'algs'
require 'set'

include Util


def display s1, s2
  p(lcs(s1.split(''), s2.split(''), 0, 0).join(''))
  p(fast_lcs(s1.split(''), s2.split('')).join(''))
  #p(lcsf(s1, s2))
end

def writef s1, s2
  show_elapsed_time('LCS') do
    #write('data/out3.txt', lcs(s1.split(''), s2.split(''), 0, 0).join(''))
    #write('data/out3.txt', lcsf(s1, s2))
    write('data/out3.txt', fast_lcs(s1.split(''), s2.split('')).join(''))
  end
end

s1 = 'AACCTTGG'
s2 = 'ACACTGTGA'

#display(s1, s2)

s3 = 'AAADBBCMC'
s4 = 'CMCAADBBCC'

#display(s3, s4)

dat = read_args('data/p3.txt', false)
s1 = dat[0]
s2 = dat[1]
writef(s1, s2)


#p lcs(a1, a2, 0, 0).join('')
#show_elapsed_time('LCS') do
#  write('data/out3.txt', lcs(a1, a2, 0, 0).join(''))
#end