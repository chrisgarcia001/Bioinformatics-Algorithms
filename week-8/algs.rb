require 'set'

# --- Coursera problem 8.1 - Greedy sorting problem -----------------------------------
def greedy_sort perm
  seq = []
  curr = perm.clone
  1.upto(perm.length) do |pos|
    ind = curr.index(pos) || curr.index(-pos)
    if ind > pos - 1
      sub = curr[(pos - 1)..ind].map{|x| -x}
      curr[(pos - 1)..ind] = sub.reverse
      if curr[pos - 1] < 0
        seq << curr
        curr = curr.clone
        curr[pos - 1] = - curr[pos - 1]
      end
      seq << curr
      curr = curr.clone
    elsif curr[pos - 1] < 0
      curr[pos - 1] = -curr[pos - 1]
      seq << curr
      curr = curr.clone
    end
  end
  seq
end

# --- Coursera problem 8.2 - Breakpoint count problem ---------------------------------
def breakpoint_count sequence
  seq = [0] + sequence + [sequence.length + 1]
  count = 0
  0.upto(seq.length - 2) do |i|
    count += 1 if seq[i + 1] != seq[i] + 1
  end
  count
end

# --- Coursera problem 8.3 - 2-break distance problem ---------------------------------
def blocks g1, g2
  (g1 + g2).flatten.map{|x| x.abs}.sort.uniq
end

def cycle_count graph
  graph = graph.clone
  count = 0
  while !graph.empty?
    u = graph.keys.first
    v = (graph[u] ? graph[u].first : nil)
    graph[u].delete(v)
    graph.delete(u) if graph[u].empty?
    while v and u != v
      w = (graph[v] ? graph[v].first : nil)
      graph[v].delete(w) if graph[v]
      graph.delete(v) if graph[v] and graph[v].empty?
      v = w
    end
    count += 1 if u == v
  end
  count
end

def get_strands gen
  return [] if !gen or gen.empty?
  s1 = gen.select{|x| !x.is_a?(Array)}
  s2 = gen.select{|x| x.is_a?(Array)}
  (s1.empty? ? [] : [s1]) + get_strands(s2.first) + get_strands(s2[1..s2.length]) 
end

def breakpoint_graph g1, g2
  graph = {}
  strands = []
  get_strands([g1, g2]).each do |g|
    0.upto(g.length - 2){|i| graph[g[i]] = [] if !graph[g[i]]; graph[g[i]] << g[i + 1]}
    graph[g.last] = [] if !graph[g.last]
    graph[g.last] << g.first
  end
  graph  
end

def two_break_dist g1, g2
  blocks(g1, g2).length - cycle_count(breakpoint_graph(g1, g2)) - 3
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

# Septic problem 2.2
def reverse_complement dna, comps={'A'=>'T','T'=>'A','C'=>'G','G'=>'C'}
  dna.split('').map{|c| comps[c]}.reverse.join('')
end

def shared_kmers k, seq1, seq2
  s1 = indexed_kmers(k, seq1)
  s2 = indexed_kmers(k, seq2)
  pairs = []
  s1.each do |kmer, s1_inds|
    s2_inds = (s2[kmer] || []) + (s2[reverse_complement(kmer)] || [])
    s1_inds.each{|i| s2_inds.each{|j| pairs << [i, j]}}
  end
  pairs.uniq
end


