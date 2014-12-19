require 'set'


# This is Stepic problem 2.1
def k_mers string, k
  chars = string.split('')
  freqs = {}
  i = 0
  maxv = 0
  while i + k - 1 < chars.length do
    s  = string[i..i + k - 1]
    freqs[s] = 0 if !freqs[s] 
    freqs[s] += 1
    maxv = freqs[s] if freqs[s] > maxv
    i += 1
  end
  freqs.select{|key, val| val == maxv}.map{|x| x.first}
end

# Septic problem 2.2
def reverse_complement dna, comps={'A'=>'T','T'=>'A','C'=>'G','G'=>'C'}
  dna.split('').map{|c| comps[c]}.reverse.join('')
end

# Stepic problem 2.3
def pattern_match string, pattern
  str = string.split('')
  pat = pattern.split('')
  matches = []
  i = 0
  while i + pat.length - 1 < str.length do
    matches << i if str[i..(i + pat.length - 1)] == pat
    i += 1
  end
  matches
end

# Stepic problem 2.4
def find_clumps k, window_len, min_occurs, dna
  i = 0
  h = {}
  found = Set.new
  while i + k - 1 < dna.length do
    nxt = dna[i..(i + k - 1)]
    if !found.member?(nxt)
      h[nxt] = [] if !h[nxt]
      h[nxt] << i
      if h[nxt].length >= min_occurs
        kback = h[nxt][h[nxt].length - min_occurs]
        found << nxt if i + k - kback <= window_len
      end
    end
    i += 1
  end
  found.to_a
end

# Stepic problem 2.5
def skew segment
  skewv = 0
  segment.split('').each do |c|
    if c == 'G' 
      skewv += 1
    elsif c == 'C'  
      skewv -= 1
    end
  end
  skewv
end

def all_prefix_skews dna
  skews = []
  0.upto(dna.length - 1) do |i|
    skew = 0
    if dna[i..i] == 'G' 
      skew += 1
    elsif dna[i..i] == 'C'  
      skew -= 1
    end   
    skews << (skews.last || 0) + skew
  end
  skews
end

def min_skew dna
  min_inds = []
  min_skew = 0
  curr_skew = 0
  dna.split('').each_with_index do |c, i|
    if c == 'G' 
      curr_skew += 1
    elsif c == 'C'  
      curr_skew -= 1
    end
    if curr_skew == min_skew
      min_inds << i
    elsif curr_skew < min_skew
      min_skew = curr_skew
      min_inds = [i]
    end
  end
  min_inds
end

# Stepic problem 2.6
def approximate_match pattern, text, d
  pat = pattern.split('')
  txt = text.split('')
  i = 0
  inds = []
  while i + pat.length <= txt.length do
    mismatches = 0
    pairs = [pat, txt[i..(i + pat.length - 1)]].transpose
    j = 0
    while j < pairs.length do 
      mismatches += 1 if pairs[j][0] != pairs[j][1]
      j = pairs.length if mismatches > d
      j += 1
    end
    inds << i if mismatches <= d
    i += 1
  end
  inds
end

# Stepic probelm 2.7 ------ ineffecient approaches
def mismatches a, b
  ap = a
  bp = b
  ap = a.split('') if a.is_a?(String)
  bp = b.split('') if b.is_a?(String)
  [ap, bp].transpose.select{|pr| pr[0] != pr[1]}.length
end

def mismatches_within(a, b, d)
  i = 0
  mm = 0
  within = true
  while i < a.length do
    mm += 1 if a[i] != b[i]
    i += 1
    if mm > d
      i = a.length + 1 
      within = false
    end
  end
  within
end

def frequent_words_with_mismatches_included_only text, k, d
  freqs = {}
  i = 0
  while i + k - 1 < text.length do
    curr = text[i..(i + k - 1)]
    freqs[curr] = 0 if !freqs[curr]
    freqs.keys.each{|pat| freqs[pat] += 1 if mismatches(pat, curr) <= d}
    i += 1
  end
  maxv = 0
  words = []
  freqs.each do |word, count|
    if count > maxv
      words = [word]
      maxv = count
    elsif count == maxv
      words << word
    end
  end
  words
end

def all_sequences elements, length
  return [] if length == 0
  return elements.map{|x| [x]} if length == 1
  suffixes = all_sequences(elements, length - 1)
  seqs = []
  elements.each{|e| suffixes.each{|s| seqs << [e] + s }}
  seqs
end

def frequent_words_with_mismatches_v0 text, k, d
  freqs = {}
  seqs = all_sequences(['A', 'C', 'G', 'T'], k).map{|s| s.join('')}
  i = 0
  kmer_freqs = k_mer_freqs(text, k)
  maxv = 0
  words = []
  seqs.each do |word|
    matches = 0
    kmer_freqs.each{|kmer, count| matches += count if mismatches_within(word, kmer, d)}
    if matches > maxv
      words = [word]
      maxv = matches
    elsif matches == maxv
      words << word
    end
  end
  words
end

# --------------- 2.7 Efficient approach
def k_mer_freqs string, k
  freqs = {}
  i = 0
  while i + k - 1 < string.length do
    s  = string[i..i + k - 1]
    freqs[s] = 0 if !freqs[s] 
    freqs[s] += 1
    i += 1
  end
  freqs
end

def ncombs from, to, n
  return [[]] if n == 0
  return [(from..to).to_a] if (to - from + 1) <= n
  return (from..to).to_a.map{|x| [x]} if n == 1
  nxt = ncombs(from + 1, to, n - 1)
  nxt.map{|cmb| [from] + cmb} + ncombs(from + 1, to, n)
end

def positional_mismatches text, positions, chars = ['A','C','T','G']
  return [text] if positions.empty?
  misms = []
  rem = positional_mismatches(text, positions[1..positions.length])
  others = chars - [text[(positions.first)..(positions.first)]]
  others.each do |oth|
    rem.each do |r|
      s = String.new(r)
      s[positions.first] = oth
      misms << s
    end
  end
  misms
end

# Final algorithm version
def frequent_words_with_mismatches text, k, d
  freqs = {}
  kmer_freqs = k_mer_freqs(text, k)
  pos_sets = Set.new
  0.upto(d) do |i|
    pos_sets += ncombs(0, k - 1, i)
  end
  #p pos_sets.to_a
  maxv = 0
  words = []
  kmer_freqs.each do |kmer, count|
    pos_sets.each do |pos|
      mms = positional_mismatches(kmer, pos)
      #p pos
      mms.each do |m|
        if !freqs[m]
          freqs[m] = count
        else
          freqs[m] += count
        end
        if freqs[m] > maxv
          words = [m]
          maxv = freqs[m]
        elsif maxv == freqs[m]
          words << m
        end
      end
    end
  end
  words
end

# Problem 2.8
def frequent_words_with_mismatches_reverse_comps text, k, d
  freqs = {}
  kmer_freqs = k_mer_freqs(text, k)
  pos_sets = Set.new
  0.upto(d) do |i|
    pos_sets += ncombs(0, k - 1, i)
  end
  #p pos_sets.to_a
  maxv = 0
  words = []
  kmer_freqs.each do |kmer, count|
    pos_sets.each do |pos|
      mms = positional_mismatches(kmer, pos)
      mms += mms.map{|m| reverse_complement(m)}
      #p pos
      mms.each do |m|
        if !freqs[m]
          freqs[m] = count
        else
          freqs[m] += count
        end
        if freqs[m] > maxv
          words = [m]
          maxv = freqs[m]
        elsif maxv == freqs[m]
          words << m
        end
      end
    end
  end
  words
end



