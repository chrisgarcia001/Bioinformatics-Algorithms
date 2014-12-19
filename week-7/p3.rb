require 'util'
require 'algs'
require 'set'

include Util


def print sol
  puts sol[:s1].join('')
  puts sol[:s2].join('')
  puts 'Weight: ' + sol[:w].to_s
end

def writef s1, s2, outfile
  show_elapsed_time('Overlap Alignment') do
    sol = overlap_align(s1.split(''), s2.split(''))
    data = [sol[:w].to_s, sol[:s1].join(''), sol[:s2].join('')].join("\n")
    write(outfile, data)
  end  
end

# ------------------ MAIN -----------------------------
v = 'PAWHEAE'
w = 'HEAGAWGHEE'
print overlap_align(v.split(''), w.split(''))
v = 'CTAAGGGATTCCGGTAATTAGACAG'
w = 'ATAGACCATATGTCAGTGACTGTGTAA'
#p prefix('12345'.split(''), 0)
#p suffix('12345'.split(''), 0)

#print fast_overlap_align(v.split(''), w.split(''))
print overlap_align(v.split(''), w.split(''))
infile = 'data/p3.txt'
outfile = 'data/out3.txt'
v, w = read_lines(infile)
#print overlap_align(v.split(''), w.split(''))
writef(v, w, outfile)
