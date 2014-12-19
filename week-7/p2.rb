require 'util'
require 'algs'
require 'set'

include Util

def print sol
  puts sol[:vp].join('')
  puts sol[:wp].join('')
  puts 'Weight: ' + sol[:w].to_s
end

def writef v, w, outfile
  show_elapsed_time('Fitting Alignment') do
    sol = fitting_alignment(v.split(''), w.split(''))
    data = [sol[:w].to_s, sol[:vp].join(''), sol[:wp].join('')].join("\n")
    write(outfile, data)
  end  
end

# ------------------ MAIN -----------------------------
v = 'GTAGGCTTAAGGTTA'
w = 'TAGATA'
print fitting_alignment(v.split(''), w.split(''))

v = 'AAATTTAAA'
w = 'TATA'
print fitting_alignment(v.split(''), w.split(''))

v = 'AAAAAAAAAAAATTATAA'
w = 'TTT'
print fitting_alignment(v.split(''), w.split(''))


infile = 'data/p2.txt'
outfile = 'data/out2.txt'
v, w = read_lines(infile)
#print fitting_alignment(v.split(''), w.split(''))
writef(v, w, outfile)
