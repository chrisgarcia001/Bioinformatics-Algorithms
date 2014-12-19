# --- Coursera problem 9.6 - Shortest non-shared substrings problem -------------------
def shortest_nonshared_substrings s1, s2, from = 0, to = ([s1.length, s2.length].min - 1)
  if from == to
    return distinct_kmers(to, s1, s2)
  elsif from == to - 1
    a = distinct_kmers(from, s1, s2)
    b = distinct_kmers(to, s1, s2)
    b = a if b.empty?
    return b
  end
  mid = from + ((to - from) / 2)
  kmers = distinct_kmers(mid, s1, s2)
  if kmers.empty?
    return shortest_nonshared_substrings(s1, s2, from, mid)
  else
    return shortest_nonshared_substrings(s1, s2, mid, to)
  end
end

# --- Coursera problem 9.5 - Suffix tree construction problem -------------------------
def longest_shared_substring s1, s2
  sufs1 = all_suffixes(s1)
  root = SuffixTreeNode.new
  sufs1.each{|s| root.add(s)}
  sufs2 = all_suffixes(s2)
  best = []
  sufs2.each do |s|
    nxt = root.overlay(s)
    best = nxt if nxt.length > best.length
  end
  best
end


# --- Coursera problem 9.3 - Suffix tree construction problem -------------------------
class SuffixTreeNode
  attr_reader :sequence
  
  def initialize seq = [], nxt = []
    @sequence = (seq.is_a?(Array) ? seq : seq.split(''))
    @next = nxt
  end
  
  def add seq
    if @sequence.empty?
      i = 0; added = false
      while i < @next.length and !added
        added = @next[i].add(seq)
        i += 1
      end
      @next << SuffixTreeNode.new(seq) if !added
      return true
    end
    common = common_prefix(@sequence, seq)
    return false if common.empty?
    if common.length < @sequence.length
      next_node = SuffixTreeNode.new(@sequence[common.length..@sequence.length], @next)
      @sequence = common
      @next = [next_node]
    else
      rem = seq[common.length..seq.length]
      i = 0; added = false
      while i < @next.length and !added
        added = @next[i].add(rem)
        i += 1
      end
      @next << SuffixTreeNode.new(rem) if !added
    end
    true
  end
  
  def add_descendant_sequences seqs = []
    seqs << @sequence
    @next.each{|node| node.add_descendant_sequences(seqs)}
    seqs
  end
  
  def debug_str
    return [@sequence.join('')] if @next.empty?
    nxt = []
    @next.each{|n| nxt += n.debug_str}
    nxt.map{|x| @sequence.join('') + '-' + x}
  end
  
end

def suffix_tree_edges seq
  sufs = all_suffixes(seq)
  root = SuffixTreeNode.new
  sufs.each{|s| root.add(s)}
  sufs.each{|s| root.add(s)}
  sufs.each{|s| root.add(s)}
  fseqs = root.add_descendant_sequences([])
  fseqs.delete([])
  fseqs
  #fseqs.debug_str.each{|s| puts s}
  #root.debug_str.each{|s| puts s}
end


# --- Coursera problem 8.3 - Longest repeat problem -----------------------------------
# -- Note: From week 8
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

def bf_longest_repeat seq
  (seq.length - 1).downto(1) do |k|
    kmer_inds = indexed_kmers(k, seq)
    kmer_inds.each{|kmer, inds| return kmer if inds.length > 1}
  end
end

# -------------- Attempt 2 ------------
def longest_prefix s1, s2
  s1 = s1.split('') if !s1.is_a?(Array)
  s2 = s2.split('') if !s2.is_a?(Array)
  i = 0
  pref = []
  while i < [s1.length, s2.length].min and s1[i] == s2[i]
    pref << s1[i]
    i += 1
  end
  pref
end

def all_suffixes string
  string = string.split('') if !string.is_a?(Array)
  sufs = []
  0.upto(string.length - 1){|i| sufs << string[i..string.length]}
  sufs
end

def longest_repeat seq
  sufs = all_suffixes(seq)
  best = []
  i = 0
  while i < seq.length - 1 and best.length < (seq.length - i - 1)
    j = i + 1
    while j < seq.length and best.length < (seq.length - j - 1)
      pref = longest_prefix(sufs[i], sufs[j])
      best = pref if pref.length > best.length
      j += 1
    end
    i += 1
  end
  best.join('')
end