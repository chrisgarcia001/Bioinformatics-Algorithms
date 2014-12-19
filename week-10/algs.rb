require 'set'
require 'rubygems'
require 'pmap'

# --- Common Utils --------------------------------------------------------------------
def rotate str #seq 
  str[(str.length - 1)..(str.length - 1)] + (str[0..str.length - 2] || [])
end

def rev_rotate str
  (str[1..str.length] || []) + str[0..0]
end

def sym_counts seq
  counts = {}
  seq = seq.split('') if seq.is_a?(String)
  seq.each do |c|
    counts[c] = 0 if !counts.has_key?(c)
    counts[c] += 1
  end
  counts
end

def enum sym, i, n
  suf = ''
  1.upto(n.to_s.length - i.to_s.length){suf << '0'}
  sym + '-' + suf + i.to_s
end

def de_enum sym
  sym[0..0]
end

def enum_syms seq
  seq = seq.split('') if seq.is_a?(String)
  counts = sym_counts(seq)
  curr = {}
  counts.keys.each{|sym| curr[sym] = 0}
  enum_seq = []
  seq.each do |sym|
    curr[sym] += 1
    enum_seq << enum(sym, curr[sym], counts[sym])
  end
  enum_seq
end

def unique_counts strings
  h = {}
  strings.each do |s|
    h[s] = 0 if !h.has_key?(s)
    h[s] += 1
  end
  h
end

# --- Coursera problem 8.4 - 2-break distance problem ---------------------------------
def indexed_kmers k, seq
  kmers = {}
  i = 0
  while i + k - 1 < seq.length
    kmer = seq[i..(i + k - 1)]
    kmers[kmer] = [] if !kmers.has_key?(kmer)
    kmers[kmer] << i
    i += 1
  end
  kmers
end

# --------------- From week 9 ---------------------------------------------------------

## --- Coursera problem 9.2 - Multiple pattern matching problem -----------------------
def brute_force_matches string, pattern
  i = 0
  pos = []
  while i + pattern.length - 1 < string.length
    pos << i if string[i..(i + pattern.length - 1)] == pattern
    i += 1
  end
  pos
end

def bf_multi_pattern_match string, patterns
  inds = []
  patterns.each{|pat| inds << brute_force_matches(string, pat)}
  inds
end

# --- Coursera problem 9.7 - Suffix array construction problem ------------------------
def suffix_array text
  sufs = {}
  0.upto(text.length - 1){|i| sufs[text[i..text.length]] = i}
  lexo_sufs = sufs.keys.sort
  array = []
  lexo_sufs.each{|s| array << sufs[s]}
  array
end

# --- Coursera problem 10.1 - Burrows-Wheeler construction problem --------------------
def borrows_wheeler_construction str
  strings = []
  string = str.clone#(str.is_a?(String) ? str.split('') : str.clone)
  1.upto(str.length) do
    strings << string 
    string = rotate(string)
  end
  #p strings
  strings.sort.map{|s| s[(s.length - 1)..(s.length - 1)]}.join('')
end

# --- Coursera problem 10.2 - Burrows-Wheeler transform problem -----------------------
def bwt seq
  in_string_format = seq.is_a?(String)
  seq = seq.split('') if in_string_format
  first = enum_syms(seq.sort)
  last = enum_syms(seq)
  curr = first[0]
  inv_seq = []
  while inv_seq.length < seq.length
    inv_seq << de_enum(curr)
    curr = first[last.index(curr)]
  end
  inv_seq = inv_seq.join('') if in_string_format
  #inv_seq
  rev_rotate(inv_seq)
end

# --- Coursera problem 10.3 and 10.4 - Burrows-Wheeler matching problem ---------------
def bwt_match string, patterns
  inds = []
  bwts = bwt(string)
  patterns.each{|pat| inds << brute_force_matches(bwts, pat)}
  inds.map{|a| a.length}
end

# --- Coursera problem 10.5 - Partial suffix problem ----------------------------------
def partial_suffix_array text, k
  suff_arr = suffix_array(text)
  maxv = suff_arr.max
  curr = 0
  mults = []
  while curr * k <= maxv
    mults << curr * k
    curr += 1
  end
  partial = []
  0.upto(suff_arr.length - 1) do |row|
    mult = mults.delete(suff_arr[row])
    partial << [row, mult] if mult
  end
  partial
end

# --- Coursera problem 10.7 - Multiple approximate matching problem -------------------
def matches_within seq, pattern, d
  i = 0
  inds = []
  while i + pattern.length - 1 < seq.length
    j = 0
    miss = 0
    while j < pattern.length and miss <= d
      miss += 1 if seq[i + j] != pattern[j]
      j += 1
    end
    inds << i if miss <= d
    i += 1
  end
  inds
end

def multiple_approx_pattern_matches text, patterns, d
  seq = text.split('')
  pats = patterns.map{|x| x.split('')}
  #pats.map{|pat| matches_within(seq, pat, d)}
  pats.pmap{|pat| matches_within(seq, pat, d)}
end


#indexed_kmers k, seq
#unique_counts str

