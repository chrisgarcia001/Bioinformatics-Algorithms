require 'set'

# ----------------- Util methods -----------------------------------
def dna_to_rna dna
  dna.split('').map{|c| c == 'T' ? 'U' : c}.join('')
end 

def rna_to_dna rna
  dna.split('').map{|c| c == 'U' ? 'T' : c}.join('')
end

def mass_spec code, table = nil
  return code.reduce{|x, y| x + y} if !table
  mass = 0
  code = code.split('') if code.is_a?(String)
  if table
    code.each{|a| mass += (table[a] || 0)}
  end
  mass
end

# Septic problem 2.2
def reverse_complement dna, comps={'A'=>'T','T'=>'A','C'=>'G','G'=>'C'}
  dna.split('').map{|c| comps[c]}.reverse.join('')
end

def nchunk text, n
  return [text] if text.length <= n
  [text[0..(n - 1)]] + nchunk(text[n..text.length], n)
end

def powerset elements
  return [[]] if elements.empty?
  rem = powerset elements[1..elements.length]
  rem.map{|s| [elements.first] + s} + rem
end

def powerseq seq
  return [[]] if seq.empty?
  curr = (0..seq.length - 1).to_a.map{|i| seq[0..i]}
  curr + powerseq(seq[1..seq.length])
end

def all_rotations seq
  rots = []
  return rots if seq.empty?
  s = Array.new(seq)
  1.upto(seq.length) do
    rots << seq
    lst = seq.last
    fst = seq[0..seq.length - 2]
    seq = [lst] + fst
  end
  rots
end

def freq_table array
  h = {}
  array.each do |v|
    h[v] = 0 if !h[v]
    h[v] += 1
  end
  h
end
#---------------------------------------------------------------------

# Coursera problem 2.1
def protein_translation text, codon_table, stop='X'
  i = 0
  trans = ''
  while i + 3 <= text.length do
    nxt = codon_table[text[i..(i + 2)]]
    trans << nxt if nxt and nxt != stop
    i += 3
  end
  trans
end

# Coursera problem 2.2
def peptide_encoding text, peptide, table
  seqs = []
  i = 0
  while i + (3 * peptide.length) - 1 < text.length do
    segment = text[i..(i + (3 * peptide.length) - 1)]
    code = nchunk(segment, 3)
    rev_code = nchunk(reverse_complement(segment), 3)
    match = true
    code.each_with_index{|m, j| match = false if table[m] != peptide[j..j]}
    if !match
      match = true
      rev_code.each_with_index{|m, j| match = false if table[m] != peptide[j..j]}
    end
    seqs << segment if match
    i += 1
  end
  seqs
end

# Coursera problem 2.3
def cyclospectrum peptide, table = nil
  pep = peptide.is_a?(String) ? peptide.split('') : peptide
  rots = all_rotations(pep)
  elements = []
  0.upto(pep.length - 2) do |i|
    rots.each do |seq| 
      elements << seq[0..i]
    end
  end
  masses = [0]
  elements.each{|e| masses << mass_spec(e, table)}
  masses << mass_spec(pep, table)
  masses.to_a.sort
end

# Coursera problem 2.4
def cyclospec_freq peptide, table = nil
  freq_table(cyclospectrum(peptide, table))
end

def compatible? pept, spec_freq
  pep = pept.is_a?(Array) ? freq_table(pept) : pept
  pep.each{|amino, freq| return false if !spec_freq[amino] or freq > spec_freq[amino]}
  true
end

#def cyclopep_seq spec_freq, aminos, curr, found
#  list = curr.select{|pep| compatible?(pep, spec_freq)}
#  return found if list.empty?
#  nextr = []
#  list.each do |pep|
#    aminos.each do |a|
#      np = pep + [a]
#      found << np if cyclospec_freq(np) == spec_freq
#      nextr << np
#    end
#  end
#  cyclopep_seq(spec_freq, aminos, nextr, found)
#end

def cyclopep_seq spec_freq, aminos, list, found
  return found if list.empty?
  nextr = Set.new
  list.each do |pep|
    aminos.each do |a|
      np = pep + [a]
      nextr << np if !nextr.member?(np) and compatible?(np, spec_freq)
      found << np if !found.member?(np) and cyclospec_freq(np) == spec_freq
    end
  end
  cyclopep_seq(spec_freq, aminos, nextr, found)
end

#def cyclopeptide_seq spectrum, aminos
#  amin = aminos
#  cyclopep_seq(freq_table(spectrum), amin, [[]], Set.new).to_a.map{|pep| pep.map{|a| a.to_s}.join('-')}
#end

def cyclopeptide_seq_0 spectrum, aminos
  spec_freq = freq_table(spectrum)
  list = [[]]
  nextr = Set.new
  found = Set.new
  while !list.empty? do
    #compat_hash = {}
    #found_hash = {}
    list.each do |pep|
      aminos.each do |a|
        np = pep + [a]
        #compat_hash[np] = compatible?(np, spec_freq) if compat_hash[np] == nil
        #found_hash[np] = (cyclospec_freq(np) == spec_freq) if found_hash[np] == nil
        nextr << np if !nextr.member?(np) and compatible?(np, spec_freq)
        found << np if !found.member?(np) and cyclospec_freq(np) == spec_freq
        #nextr << np if compat_hash[np]
        #found << np if found_hash[np]
      end
    end
    #p Time.now
    p list.length
    #p list.class
    list = nextr
    nextr = Set.new
  end
  found.to_a.map{|pep| pep.map{|a| a.to_s}.join('-')}
end

def rotation? pep1, pep2
  return false if pep1.length != pep2.length
  rots = all_rotations(pep1)
  rots.each{|r| return true if r == pep2}
  false
end

def cyclopeptide_seq spectrum, aminos
  aminos = aminos.select{|a| spectrum.member?(a)}
  spec_freq = freq_table(spectrum)
  aminos = aminos.select{|a| spectrum.member?(a)}
  list = [[]]
  nextr = []#Set.new
  found = []#Set.new
  #seen = {}
  while !list.empty? do
    #compat_hash = {}
    #found_hash = {}
    seen = {}
    list.each do |pep|
      aminos.each do |a|
        np = pep.clone
        np << a
        if !seen[np] and compatible?(np, spec_freq)# and !nextr.any?{|w| rotation?(w, np)}
          rots = all_rotations(np)
          rots.each{|rot| seen[rot] = true}
          nextr << np
          found << np if cyclospec_freq(np) == spec_freq
        end
      end
    end
    p list.length
    list = nextr
    nextr = []#Set.new
  end
  all = []
  found.each{|f| all += all_rotations(f)}
  all.map{|pep| pep.map{|a| a.to_s}.join('-')}
end

def expand list, aminos
  nr = []
  list.each{|pep| aminos.each{|a| nr << pep + [a]}}
  nr
end

def cyclopeptide_seq_1 spectrum, aminos
  aminos = aminos.select{|a| spectrum.member?(a)}
  spec_freq = freq_table(spectrum)
  list = [[]]
  found = []
  seen = {}
  while !list.empty? do
    p list.length
    list = expand(list, aminos)
    nextr = []
    list.each do |pep|
      if cyclospec_freq(pep) == spec_freq
        found << pep
      elsif compatible?(pep, spec_freq) 
        nextr << pep
      end
    end
    list = nextr
  end
  found.map{|pep| pep.map{|a| a.to_s}.join('-')}
end

# -------- Coursera problem 2.5 ---------------
class Leaderboard
  attr_reader :elts
  
  def initialize n, keep_ties = true
    @elts = []
    @n = n
    @ties = keep_ties
  end
  
  def add val, score
    if @elts.empty? and @n > 0
      @elts << [val, score]
    else
      i = 0
      added = false
      while i < @elts.length
        if score >= @elts[i][1]
          @elts.insert(i, [val, score])
          i = @elts.length
          added = true
        end
        i += 1
      end
      @elts << [val, score] if !added
      if !@ties
        @elts = @elts[0..(@n - 1)]
        #@elts.delete_at(@elts.length - 1) if @elts.length > @n
      else
        while @elts.length > @n and @elts.last[1] < @elts[@n - 1][1] do
          @elts.delete_at(@elts.length - 1)
        end
      end
    end
  end
  
  def elements
    @elts.map{|x| x[0]}
  end
  
  def empty?
    @elts.empty?
  end
  
  def each &block
    @elts.each(&block)
  end
  
end

def score pept, spec
  if spec.is_a?(Array)
    spec = freq_table(spec)
  else
    spec = spec.clone
  end
  score = 0
  pept.each do |a|
    if spec[a] and spec[a] > 0
      spec[a] -= 1
      score += 1
    end
  end
  score
end

def total_mass pept
  pept.reduce{|x, y| x + y} || 0
end

def leaderboard_cyclopeptide_seq spectrum, aminos, n, keep_ties = true
  parent_mass = spectrum.max
  board = Leaderboard.new(n, keep_ties)
  board.add([], 0)
  spec_freq = freq_table(spectrum)
  best = [] # best peptide
  best_score = 0
  nextb = Leaderboard.new(n, keep_ties)
  while !board.empty? do
    puts 'Length: ' + board.elts.length.to_s
    board.each do |pr|
      pep = pr[0]
      aminos.each do |a|
        np = pep.clone 
        np << a
        sc = score(cyclospectrum(np), spec_freq)
        nextb.add(np, sc) if total_mass(np) <= parent_mass
        if total_mass(np) == parent_mass and sc > best_score
          best = np
          best_score = sc
        end
      end
    end
    board = nextb
    nextb = Leaderboard.new(n, keep_ties)
  end
  best.join('-')
end

def cyclopeptide_seq_2 spectrum, aminos, n, keep_ties = true
  parent_mass = spectrum.max
  board = Leaderboard.new(n, keep_ties)
  board.add([], 0)
  spec_freq = freq_table(spectrum)
  best = []#[[[], 0]] # best peptide
  nextb = Leaderboard.new(n, keep_ties)
  while !board.empty? do
    puts 'Length: ' + board.elts.length.to_s
    board.each do |pr|
      pep = pr[0]
      aminos.each do |a|
        np = pep.clone 
        np << a
        sc = score(cyclospectrum(np), spec_freq)
        nextb.add(np, sc) if total_mass(np) <= parent_mass
        if total_mass(np) == parent_mass #and sc > best_score
          if best.empty? or sc > best[0][1]
            best = [pr]
          elsif sc == best[0][1]
            best << pr
          end
        end
      end
    end
    board = nextb
    nextb = Leaderboard.new(n, keep_ties)
  end
  best
  #best.map{|b| b.map{|x| x.to_s}.join('-')}  
end

# --- Coursera problem 2.6 - convolution spectrum
def spectral_convolution spectrum
  i = 0
  conv = []
  while i < spectrum.length - 1 do
    j = i + 1
    while j < spectrum.length do
      conv << (spectrum[i] - spectrum[j]).abs
      j += 1
    end
    i += 1
  end
  conv - [0]
end

# --- Coursera problem 2.7 - convolution cyclopeptide sequencing
def most_frequent spec, m, lb = 57, ub = 200
  board = Leaderboard.new(m)
  freqs = freq_table(spec.select{|x| x >= lb and x <= ub})
  freqs.each{|pep, freq| board.add(pep, freq)}
  board.elts.map{|e| e[0]}
end

def conv_seq m, n, spec
  aminos = most_frequent(spectral_convolution(spec), m, 57, 200)
  leaderboard_cyclopeptide_seq(spec, aminos, n)
end
