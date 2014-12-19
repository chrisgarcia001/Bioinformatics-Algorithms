require 'set'

#------------------------------------- Week 1 ----------------------------------
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

def all_mismatches string, d, upto_d = true, alphabet = ['A','C','T','G']
  pos = ncombs(0, string.length - 1, d)
  0.upto(d - 1){|i| pos += ncombs(0, string.length - 1, i)} if upto_d
  vals = pos.map{|w| positional_mismatches(string, w, alphabet)}.flatten
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

# Stepic problem 2.6
def approximate_match text, pattern, d
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

#-------------------------------------- Week 2 ----------------------------------
def freq_table array
  h = {}
  array.each do |v|
    h[v] = 0 if !h[v]
    h[v] += 1
  end
  h
end

#--------------------------- Extra Utils ---------------------------------------

def unique_kmers string, k
  kmers = Set.new
  i = 0
  while i + k - 1 < string.length do
    kmers << string[i..(i + k - 1)]
    i += 1
  end
  kmers
end

def all_strings n, alphabet = ['A','C','T','G']
  return [] if n == 0
  return alphabet if n == 1
  rem = all_strings(n - 1, alphabet)
  strings = []
  alphabet.each{|c| strings += rem.map{|r| c + r}}
  strings
end

def hamming(s1, s2)
  s1p = s1.split('')
  s2p = s2.split('')
  dist = (s1.length - s2.length).abs
  (0..[s1.length - 1, s2.length - 1].min).each{|i| dist += 1 if s1p[i] != s2p[i]}
  dist
end

# Find the subtext within text that has the shortest hamming distance to pat, and return the dist.
# Note: this is d(Pattern, Text)
def shortest_hamming(pat, text)
  kmers = unique_kmers(text, pat.length).to_a
  best_dist = pat.length
  kmers.each do |kmer|
    nd = hamming(pat, kmer)
    if nd < best_dist
      best_dist = nd
      return 0 if best_dist == 0
    end
  end
  best_dist
end

def shortest_hamming_total(pat, text_list)
  ([0] + text_list.map{|text| shortest_hamming(pat, text)}).reduce{|x,y| x + y}
end

#-------------------------------------------------------------------------------

# Coursera problem 3.1
def motif_enum k, d, dna, alphabet = ['A','C','T','G']
  return [] if dna.empty?
  discard = Set.new
  motifs = Set.new
  kmers = unique_kmers(dna[0], k)
  rem = dna[1..dna.length]
  kmers.each do |kmer|
    nears = Set.new(all_mismatches(kmer, d, true, alphabet)) - discard
    #p nears
    nears.each do |pat|
      if rem.map{|strand| approximate_match(strand, pat, d)}.all?{|matches| !matches.empty?}
        motifs << pat
      else
        discard << pat
      end
    end
  end
  motifs
end


# Coursera problem 3.2
def median_string dna_strands, k
  best = nil
  best_score = k
  kmers = all_strings(k, ['A','C','T','G'])
  kmers.each do |kmer|
    score = shortest_hamming_total(kmer, dna_strands)
    if score < best_score or !best
      best = kmer
      best_score = score
      return kmer if best_score == 0
    end
  end
  best
end

# Get all median strings - not just first encountered
def median_strings dna_strands, k
  best = []
  best_score = k
  kmers = all_strings(k, ['A','C','T','G'])
  kmers.each do |kmer|
    score = shortest_hamming_total(kmer, dna_strands)
    if score < best_score 
      best = [kmer]
      best_score = score
    elsif score == best_score
      best << kmer
    end
  end
  best
end

# ------ Coursera problem 3.3 -----------------

# Build from a matrix where first row is alphabet
# and rest are probabilities for respective positions.
def read_profile rows
  profile = {}
  rows.transpose.each do |v|
    profile[v[0]] = v[1..v.length].map{|w| w.to_f}
  end
  profile
end

def profile_prob text, profile
  prob = 1.0
  text.split('').each_with_index do |lett, i|
    prob *= profile[lett][i]
  end
  prob
end

def profile_most_probable_kmer text, k, profile
  best_prob = 0.0
  best = nil
  unique_kmers(text, k).to_a.each do |kmer|
    nv = profile_prob(kmer, profile)
    if !best or nv > best_prob
      best = kmer
      best_prob = nv
    end
  end
  best
end

# ------ Coursera problem 3.4 -----------------
# Motifs are a list of strings
def build_profile motifs, alphabet = ['A','C','T','G']
  v = {}
  alphabet.each{|c| v[c] = []}
  return v if motifs.empty?
  len = motifs.first.length
  0.upto(len - 1) do |i|
    frqs = freq_table(motifs.map{|m| m[i..i]})
    alphabet.each do |let|
      if frqs[let]
        v[let] << (frqs[let].to_f / motifs.length.to_f) 
      else
        v[let] << 0.0
      end
    end
  end
  v
end

def score_o motifs, alphabet = ['A','C','T','G']
  profile = build_profile(motifs, alphabet)
  return 0.0 if motifs.empty?
  len = motifs.first.length
  curr = 0.0
  0.upto(len - 1) do |i|
    mp = alphabet[0]
    alphabet.each do |let|
      mp = let if profile[let][i] > profile[mp][i]
    end
    alphabet.each{|let| curr += profile[let][i] if let != mp}
  end
  curr
end

def score motifs, alphabet = ['A','C','T','G']
  return 0 if motifs.empty?
  curr = 0
  len = motifs.first.length
  curr = 0
  0.upto(len - 1) do |i|
    mp = alphabet[0]
    mpc = 0
    col = motifs.map{|c| c[i..i]}
    alphabet.each do |let|
      count = col.select{|x| x == let}.length
      (mp = let; mpc = count) if  count > mpc
    end
    alphabet.each{|let| curr += col.select{|x| x == let}.length if let != mp}
  end
  curr
end

def greedy_motif_search dna_strands, k, t, alphabet = ['A','C','T','G']
  kmer_sets = dna_strands.map{|s| unique_kmers(s, k).to_a}#.shuffle
  best_motifs = dna_strands.map{|s| s[0..(k - 1)]} #kmer_sets.map{|s| s.first}
  kmer_sets[0].each do |motif|
    motifs = [motif]
    1.upto(dna_strands.length - 1) do |i|
      profile = build_profile(motifs, alphabet)
      next_motif = profile_most_probable_kmer(dna_strands[i], k, profile)
      motifs << next_motif
    end
    best_motifs = motifs if score(motifs) < score(best_motifs)
  end
  p score(best_motifs)
  best_motifs
end

# ------ Coursera problem 3.5 -----------------

# Motifs are a list of strings
def build_pseudocount_profile motifs, alphabet = ['A','C','T','G']
  v = {}
  alphabet.each{|c| v[c] = []}
  return v if motifs.empty?
  len = motifs.first.length
  0.upto(len - 1) do |i|
    frqs = freq_table(motifs.map{|m| m[i..i]})
    frqs.keys.each{|let| frqs[let] += 1}
    den = 0.0
    alphabet.each do |let|
      if frqs[let]
        v[let] << frqs[let].to_f 
        den += frqs[let].to_f 
      else
        v[let] << 1.0
        den += 1.0
      end
    end
    alphabet.each{|let| v[let][i] = v[let][i] / den}
  end
  v
end

def greedy_motif_search_pseudocounts dna_strands, k, t, alphabet = ['A','C','T','G']
  kmer_sets = dna_strands.map{|s| unique_kmers(s, k).to_a}
  best_motifs = dna_strands.map{|s| s[0..(k - 1)]} 
  kmer_sets[0].each do |motif|
    motifs = [motif]
    1.upto(dna_strands.length - 1) do |i|
      profile = build_pseudocount_profile(motifs, alphabet)
      next_motif = profile_most_probable_kmer(dna_strands[i], k, profile)
      motifs << next_motif
    end
    best_motifs = motifs if score(motifs) < score(best_motifs)
  end
  p score(best_motifs)
  best_motifs
end

# ------ Coursera problem 3.6 -----------------

# This is the Motifs(Profile, DNA) function
def motifs profile, dna_strings
  k = profile.values.first.length
  dna_strings.map{|s| profile_most_probable_kmer(s, k, profile)}
end

def random_motifs k, dna_strings
  dna_strings.map do |s|
    ind = rand(s.length - k)
    s[ind..(ind + k - 1)]
  end
end

def randomized_motif_search_o dna_strings, k, t, iterations
  curr_motifs = random_motifs(k, dna_strings)
  best = curr_motifs
  1.upto(iterations) do
   # curr_motifs = motifs(build_pseudocount_profile(curr_motifs), dna_strings)
    curr_motifs = motifs(build_profile(curr_motifs), dna_strings)
    best = curr_motifs if score(curr_motifs) < score(best)
  end
  #p score(best)
  best
end

def randomized_motif_search dna_strings, k, t, outer, inner
  best = nil
  1.upto(outer) do
    curr_motifs = random_motifs(k, dna_strings)
    best = curr_motifs if !best or score(curr_motifs) < score(best)
    1.upto(inner) do
     # curr_motifs = motifs(build_pseudocount_profile(curr_motifs), dna_strings)
      curr_motifs = motifs(build_profile(curr_motifs), dna_strings)
      #p score(curr_motifs)
      best = curr_motifs if score(curr_motifs) < score(best)
    end
    #p score(best)
  end
  p score(best)
  best
end


# ------ Coursera problem 3.7 -----------------

class Sampler
  def initialize vals
    total = ([0] + vals).reduce{|x,y| x + y}.to_f
    @dist = []
    cum = 0.0
    vals.each do |v| 
      cum += v.to_f
      @dist << cum / total
    end
  end
  
  def get_val prb
    i = 0
    while prb > @dist[i]
      i += 1
    end
    i
  end
  
  def get_random
    get_val rand
  end
  
end

def gibbs_generator text, profile
  k = profile.values.first.length
  probs = []
  kmers = []
  i = 0
  while i + k - 1 < text.length do
    kmer = text[i..(i + k - 1)]
    kmers << kmer
    probs << profile_prob(kmer, profile)
    i += 1
  end
  [Sampler.new(probs), kmers]
end

def gibbs_sampler dna_strings, k, t, n
  curr_motifs = random_motifs(k, dna_strings)
  best = curr_motifs
  1.upto(n) do 
    i = rand(t)
    tm = curr_motifs.clone
    tm.delete_at(i)
    prof = build_pseudocount_profile(tm)
    gen = gibbs_generator(dna_strings[i], prof)
    next_motif = gen[1][gen[0].get_random]
    curr_motifs[i] = next_motif
    best = curr_motifs if score(curr_motifs) < score(best)
  end
  #p score(best)
  best
end

def local_search dna_strings, k, n
  best = nil
  1.upto(n) do
    curr = random_motifs(k, dna_strings)
    best = curr if !best or score(curr) < score(best)
  end
  p score(best)
  best
end

def meta n, &block
  best = nil
  1.upto(n) do
    nxt = block.call
    best = nxt if !best or score(nxt) < score(best)
  end
  best
end





