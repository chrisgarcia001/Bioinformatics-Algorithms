require 'set'

#--------------------------------- From Week 1 ---------------------------------
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

#------------------------------------- Utilities --------------------------------
def prefix str
  return '' if str.length <= 1
  str[0..(str.length - 2)]
end

def suffix str
  return '' if str.length <= 1
  str[1..str.length]
end

#------------------------------------ Problem Set -------------------------------
# Coursera problem 4.1
def composition text, k
  kmers = k_mer_freqs(text, k)
  comp = []
  kmers.keys.sort.each{|k| 1.upto(kmers[k]){comp << k}}
  comp
end

# Coursera problem 4.2
def overlap_graph kmers, &join #join = {|x,y| x + ' -> ' + y}
  edges = []
  for i in (0..kmers.length - 1)
    for j in (0..kmers.length - 1)
      edges << join.call(kmers[i], kmers[j]) if i != j and prefix(kmers[j]) == suffix(kmers[i])
    end
  end
  edges
end

# Coursera problem 4.3
def debrujin k, text
  edges = {}
  kmers = Set.new(composition(text, k - 1)).to_a
  for i in (0..kmers.length - 1)
    for j in (0..kmers.length - 1)
      if i != j and prefix(kmers[j]) == suffix(kmers[i])
        if edges[kmers[i]]
          edges[kmers[i]] << kmers[j]
        else
          edges[kmers[i]] = [kmers[j]]
        end
      end
    end
  end
  edges.keys.map{|v| v + ' -> ' + edges[v].join(',')}
end

# Coursera problem 4.4
def debrujin_kmers kmers, return_hash = false
  edges = {}
  kmers.each do |kmer|
    pre = prefix(kmer)
    suf = suffix(kmer)
    if edges[pre]
      edges[pre] << suf
    else
      edges[pre] = [suf]
    end
  end
  return edges if return_hash
  edges.keys.map{|k| k + ' -> ' + edges[k].join(',')}
end

# Coursera problem 4.5 ----------------------------------------------

def parse_graph raw_edge_list, outer_sep = ' -> ', inner_sep = ','
  edges = {}
  raw_edge_list.each do |st|
    link = st.split(outer_sep)
    link[1] = link[1].split(inner_sep)
    if edges[link[0]]
      edges[link[0]] += link[1]
    else
      edges[link[0]] = link[1]
    end
  end
  edges
end


def next_ind arr, &criteria
  i = 0
  while i < arr.length
    return i if criteria.call(arr[i])
    i += 1
  end
  nil
end

def euler_cycle edges, random_start = false
  cycle = []
  while !edges.empty?
    v = nil
    if random_start
      v = (cycle.empty? ? edges.keys[rand(edges.keys.length)] : cycle[next_ind(cycle){|w| edges.has_key?(w)}])
    else
      v = (cycle.empty? ? edges.keys.first : cycle[next_ind(cycle){|w| edges.has_key?(w)}])
    end
    curr = [v]
    nxt = edges[v].pop
    edges.delete(v) if edges[v].empty?
    while v != nxt
      curr << nxt
      out = edges[nxt]
      edges.delete(nxt) if edges[nxt].length == 1
      nxt = out.pop
    end
    curr << nxt
    if cycle.empty? 
      cycle = curr
    else
      ind = cycle.index(v)
      cycle[ind] = curr
      cycle = cycle.flatten
    end
  end
  cycle
end

# Coursera problem 5.1 = p6 ----------------------------
# Find the unbalanced vertices (first = more out than in, last = more in than out)
def unbalanced_vertices edges
  first = nil
  last = nil
  all = Set.new
  in_deg = {}
  out_deg = {}
  edges.each do |from, to|
   out_deg[from] = to.length
   all << from
   to.each do |v|
     in_deg[v] = 0 if !in_deg[v]
     in_deg[v] += 1
     all << v
   end
  end
  all.each do |v|
    first = v if (out_deg[v] || 0) > (in_deg[v] || 0)
    last = v if (in_deg[v] || 0) > (out_deg[v] || 0)
  end
  [first, last]
end

def euler_path edges, random_start = false
  first, last = unbalanced_vertices(edges)
  if ![first, last].member?(nil)
    edges[last] = [] if !edges[last]
    edges[last] << first
    cyc = euler_cycle(edges, random_start)
    i = 0
    while i < cyc.length - 2
      if cyc[i] == last and cyc[i + 1] == first
        part1 = cyc[(i + 1)..cyc.length]
        part2 = cyc[1..i]
        i = cyc.length
        cyc = part1 + part2
      end
      i += 1
    end
    return cyc
  else
    return euler_cycle(edges, random_start)
  end
end

# Coursera problem 5.2 = p7 ----------------------------
# Takes a sequence of k-length strings and joins them successively
# overlapping each two middle k-1 segments
def overlap_join seq
  val = ''
  seq.each do |s|
    if val.length == 0
      val = s
    else
      val += s[(s.length - 1)..(s.length - 1)]
    end
  end
  val
end

def string_reconstruct edges, random_start = false
  overlap_join(euler_path(edges, random_start))
end

# Coursera problem 5.3 = p8 ----------------------------
def all_bin_strings k
  return [''] if k == 0
  rem = all_bin_strings(k - 1)
  rem.map{|s| '0' + s} + rem.map{|s| '1' + s}
end

def univ_circular_string k, random_start = false
  s = string_reconstruct(parse_graph(debrujin_kmers(all_bin_strings(k))), random_start)
  s[0..(s.length - k)]
end

# Coursera problem 5.4 = p9 ----------------------------

def pair_prefix pair
  lhs, rhs = pair.split('|')
  return '|' if lhs.length < 2
  lhs[0..(lhs.length - 2)] + '|' + rhs[0..rhs.length - 2]
end

def pair_suffix pair
  lhs, rhs = pair.split('|')
  return '|' if lhs.length < 2
  lhs[1..lhs.length] + '|' + rhs[1..rhs.length]
end

def paired_debrujin_edges read_pairs, parsed_format = true
  edges = {}
  read_pairs.each do |pair|
    pre = pair_prefix(pair)
    suf = pair_suffix(pair)
    if edges[pre]
      edges[pre] << suf
    else
      edges[pre] = [suf]
    end
  end
  if parsed_format
    h = {}
    edges.each do |inv, out|
      h[inv.split('|').map{|x| x.split('')}] = out.map{|y| y.split('|').map{|x| x.split('')}}
    end
    return h
  end
  edges
end

# Assume each vertex v is a pair of kmers already parsed in form [["a,"b"],["c","d"]]
def rp_compatible? v, d, i, arr
  return true if arr.empty?
  ci = arr[i + v[0].length - 1]
  return true if ci == v[0].last or ci == nil
  false
end

# Assume each vertex v is a pair of kmers already parsed in form [["a,"b"],["c","d"]]
def rp_add v, d, i, arr
  a = arr.clone
  if arr.empty?
    a += v[0]
    (1 + d).times{a << nil}
    a += v[1]
    return a
  end
  a[i + v[0].length - 1] = v[0].last
  a << v[1].last
  a
end


def expand v, edges, i, d, arrs
  return nil if !rp_compatible?(v, d, i, arrs)
  return rp_add(v, d, i, arrs) if rp_compatible?(v, d, i, arrs) and edges.empty?
  out = edges[v]
  j = 0
  while j < out.length
    nv = out[j]
    newout = out.clone
    newout.delete_at(j)
    if newout.empty?
      edges.delete(v)
    else
      edges[v] = newout
    end
    sol = expand(nv, edges, i + 1, d, rp_add(v, d, i, arrs))
    return sol if sol
    j += 1
  end
  edges[v] = out
  nil
end

def reconstruct_read_pairs read_pairs, d, random_start = false
  edges = paired_debrujin_edges(read_pairs)
  first, last = unbalanced_vertices(edges)
  expand(first, edges, 0, d, []).join('')
end

# Coursera problem 5.5 = p10 ----------------------------
def in_out_degs edges
  all = Set.new
  in_deg = {}
  out_deg = {}
  edges.each do |from, to|
   out_deg[from] = to.length
   all << from
   to.each do |v|
     in_deg[v] = 0 if !in_deg[v]
     in_deg[v] += 1
     all << v
   end
  end
  all.each do |v|
    in_deg[v] = 0 if !in_deg[v]
    out_deg[v] = 0 if !out_deg[v]
  end
  [in_deg, out_deg]
end

def contigs kmers
  edges = debrujin_kmers(kmers, true)
  in_deg, out_deg = in_out_degs(edges)
  all = Set.new(in_deg.keys + out_deg.keys).to_a
  starts = all.select{|v| in_deg[v] != 1 or out_deg[v] != 1}
  nonstarts = all - starts
  paths = []
  starts.each do |s|
    outs = edges[s] || []
    outs.each do |nxt|
      path = [s]
      while nonstarts.member?(nxt)
        path << nxt
        nxt = (edges[nxt] || []).first 
      end
      path << nxt if nxt
      paths << path
    end
  end
  paths.map{|path| overlap_join(path)}
end




