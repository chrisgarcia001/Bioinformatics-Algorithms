require 'set'

# --- Common Utils --------------------------------------------------------------------
def all_suffixes string
  string = string.split('') if !string.is_a?(Array)
  sufs = []
  0.upto(string.length - 1){|i| sufs << string[i..string.length]}
  sufs
end

def common_prefix s1, s2
  s1 = s1.split('') if s1.is_a?(String)
  s2 = s2.split('') if s2.is_a?(String)
  prefix = []
  i = 0
  while i < [s1.length, s2.length].min
    if s1[i] == s2[i]
      prefix << s1[i]
    else
      i = [s1.length, s2.length].max
    end
    i += 1
  end
  prefix
end

def unique_kmers k, str
  i = 0
  kmers = Set.new
  while i + k - 1 < str.length
    kmers << str[i..(i + k - 1)]
    i += 1
  end
  kmers
end

def common_kmers k, s1, s2
  km1 = unique_kmers(k, s1)
  km2 = unique_kmers(k, s2)
  km1.intersection(km2)
end

def distinct_kmers k, s1, s2
  km1 = unique_kmers(k, s1)
  km2 = unique_kmers(k, s2)
  (km1 - km2).union(km2 - km1)
end

# --- Coursera problem 9.1 - Trie construction problem --------------------------------
class TrieNode
  attr_reader :n, :letter
  
  def initialize in_letter = nil
    @n = nil
    @letter = in_letter
    @next = []
  end
  
  def add_next letters
    letters = letters.split('') if !letters.is_a?(Array)
    if !letters.empty?
      nxt = @next.select{|x| x.letter == letters.first}.first
      #p nxt
      if !nxt
        nxt = TrieNode.new(letters.first)
        @next << nxt
      end
      nxt.add_next(letters[1..letters.length])     
    end
  end
  
  def enumerate curr = 1
    @n = curr
    @next.each{|v| curr = v.enumerate(curr + 1)}
    curr
  end
  
  def to_adj_list list = []
    @next.each do |v| 
      list << [@n, v.n, v.letter]
      v.to_adj_list(list)
    end
    list
  end
  
  def to_adj_list_str
    to_adj_list.map{|e| e.map{|x| x.to_s}.join(' ')}.join("\n")
  end
end

# --- Coursera problem 9.2 - Multiple pattern matching problem ------------------------
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

# --- Coursera problem 9.3 - Longest repeat problem -----------------------------------
class SuffixTrieNode
  attr_reader :letter, :depth, :prev
  
  def initialize in_letter = nil, prev_node = nil
    @prev = prev_node
    @depth = (@prev ? @prev.depth + 1: 0)
    @letter = in_letter
    @next = []
  end
  
  def add letters
    letters = letters.split('') if !letters.is_a?(Array)
    if !letters.empty?
      nxt = @next.select{|x| x.letter == letters.first}.first
      if !nxt
        nxt = SuffixTrieNode.new(letters.first, self)
        @next << nxt
      end
      nxt.add(letters[1..letters.length])     
    end
  end
  
  def seq_from_root
    return [self] if !@prev
    seq = @prev.seq_from_root
    seq << self
    seq
  end
    
  def deepest_node_with_min_outdegree min_degree
    return nil if @next.empty?
    best = nil
    @next.each do |nextnode|
      node = nextnode.deepest_node_with_min_outdegree(min_degree)
      best = node if !best or (node and node.depth > best.depth)
    end
    return best if best
    return self if @next.length >= min_degree
    nil
  end
  
end

def longest_repeat seq, maxlen = 10, min_repeats = 2
  sufs = all_suffixes(seq + '$').map{|s| s[0..[maxlen, s.length].min]}
  root = SuffixTrieNode.new
  sufs.each{|s| root.add(s)}
  seq = root.deepest_node_with_min_outdegree(min_repeats).seq_from_root.map{|node| node.letter}
  seq.delete('$')
  seq.join('')
end

# --- Coursera problem 9.4 - Suffix tree construction problem -------------------------
class SuffixTreeNode
  
  def initialize seq = [], nxt = []
    @seq = (seq.is_a?(Array) ? seq : seq.split(''))
    @next = nxt
  end
  
  def add seq
    if @seq.empty?
      i = 0; added = false
      while i < @next.length and !added
        added = @next[i].add(seq)
        i += 1
      end
      @next << SuffixTreeNode.new(seq) if !added
    else
      common = common_prefix(@seq, seq)
      return false if common.empty?
      if @seq == common
        rem = seq[common.length..seq.length]
        i = 0; added = false
        while i < @next.length and !added
          added = @next[i].add(rem)
          i += 1
        end
        @next << SuffixTreeNode.new(rem) if !added
      else
        rem = @seq[common.length..@seq.length]
        bottom_split_node = SuffixTreeNode.new(rem, @next)
        new_node = SuffixTreeNode.new(seq[common.length..seq.length])
        @seq = common
        @next = [bottom_split_node, new_node]
      end
    end
    true
  end
    
  def add_descendant_sequences seqs = []
    seqs << @seq
    @next.each{|node| node.add_descendant_sequences(seqs)}
    seqs
  end
  
end

def suffix_tree_edges seq
  sufs = all_suffixes(seq)
  root = SuffixTreeNode.new
  sufs.each{|s| root.add(s)}
  fseqs = root.add_descendant_sequences([])
  fseqs.delete([])
  fseqs
end

# --- Coursera problem 9.5 - Longest shared substrings problem ------------------------
def longest_shared_substrings s1, s2, from = 0, to = ([s1.length, s2.length].min - 1)
  if from == to
    return common_kmers(to, s1, s2)
  elsif from == to - 1
    a = common_kmers(from, s1, s2)
    b = common_kmers(to, s1, s2)
    b = a if b.empty?
    return b
  end
  mid = from + ((to - from) / 2)
  kmers = common_kmers(mid, s1, s2)
  if kmers.empty?
    return longest_shared_substrings(s1, s2, from, mid)
  else
    return longest_shared_substrings(s1, s2, mid, to)
  end
end

# --- Coursera problem 9.6 - Shortest non-shared substrings problem -------------------
def shortest_nonshared_substrings s1, s2
  i = 1
  distinct = Set.new
  while i < [s1.length, s2.length].min and distinct.empty?
    distinct = distinct_kmers(i, s1, s2)
    i += 1
  end
  distinct
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

# --- Coursera problem 9.8 - Suffix tree from suffix array  construction problem ------
def suffix_tree text, suff_arr, lcp
  sufs = suff_arr.map{|i| text[i..(text.length - 1)]}
  labels = []
end




