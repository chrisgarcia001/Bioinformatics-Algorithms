require 'set'

# --- Coursera problem 6.1 - change problem -------------------------------------------
def dp_change money, coins, subs = {}
  return nil if money < 1
  return 1 if coins.member?(money)
  return subs[money] if subs[money]
  best = nil
  coins.each do |coin|
    v = dp_change(money - coin, coins, subs)
    best = v if v and (!best or v < best)
  end
  subs.merge!({money => 1 + best})
  1 + best
end

# --- Coursera problem 6.2 - Manhattan tourist problem --------------------------------
def manhattan_tourist n, m, down, right
  s = [[0]]
  1.upto(n){|i| s << [s[i - 1][0] + down[i][0]]}
  1.upto(m){|j| s[0] << s[0][j - 1] + right[0][j]}
  1.upto(n) do |i|
    1.upto(m) do |j|
      s[i][j] = [s[i - 1][j] + down[i][j], s[i][j - 1] + right[i][j]].max
    end
  end
  s[n][m]
end


# --- Coursera problem 6.3 - longest common subsequence problem -----------------------
# DP recursive (only smaller problems)
def lcs a1, a2, i, j, subs = {}
  return subs[[i, j]] if subs.has_key?([i, j])
  if i == a1.length or j == a2.length
    subs[[i, j]] = []
  elsif a1[i] == a2[j]
    subs[[i,j]] = [a1[i]] + lcs(a1, a2, i + 1, j + 1) 
  else
    s1 = lcs(a1, a2, i + 1, j, subs)
    s2 = lcs(a1, a2, i, j + 1, subs)
    subs[[i, j]] = (s1.length > s2.length ? s1 : s2)
  end
  subs[[i,j]]
end


# -- Fast version (From: http://www.ics.uci.edu/~eppstein/161/960229.html)
def build_matrix rows, columns, initv= nil
  mat = []
  1.upto(rows) do
    row = []
    1.upto(columns) do
      row << initv
    end
    mat << row
  end
  mat
end

def fast_lcs a, b
  mat = build_matrix(a.length + 1, b.length + 1)
  (a.length).downto(0) do |i|
    (b.length).downto(0) do |j|
      if a[i] == nil or b[j] == nil
        mat[i][j] = 0
      elsif a[i] == b[j]
        mat[i][j] = 1 + mat[i + 1][j + 1]
      else
        p1 = mat[i + 1][j]
        p2 = mat[i][j + 1]
        mat[i][j] = [p1, p2].max
      end
    end
  end
  
  s = []
  i = 0; j = 0
  while i < a.length and j < b.length
    if a[i] == b[j]
      s << a[i]
      i += 1; j += 1
    elsif mat[i + 1][j] >= mat[i][j + 1]
      i += 1
    else
      j += 1
    end
  end
  s
end

# --- Coursera problem 6.4 - Longest Path in DAG --------------------------------------
def build_graph edges
  g = {}
  ins = Set.new
  outs = Set.new
  edges.each do |e|
    inv, out = e.split('->')
    outv, outws = out.split(':')
    outw = outws.to_i
    ins << inv
    outs << outv
    g[outv] = [] if !g.has_key?(outv)
    g[outv] << {:from => inv, :weight => outw}
  end
  {:edges => g, :sources => (ins - outs).to_a, :sinks => (outs - ins).to_a}
  # NOTE: edges here is of form {vertex => {from, weight}} = nodes COMING INTO vertex format.
end

# Note: v is a destination vertex. This algorithm takes a work-backward approach.
def lp_dag v, edges, subs = {}
  return subs[v] if subs.has_key?(v)
  if !edges.has_key?(v) or edges[v].empty?
    subs[v] = {:path => [v], :weight => 0}
    return subs[v]
  end
  invs = edges[v].map{|iv| iv[:from]}
  inws = edges[v].map{|iv| iv[:weight]}
  psubs = [] 
  invs.each{|iv| psubs << lp_dag(iv, edges, subs)}
  best = {:path => psubs.first[:path] + [v], 
          :weight => psubs.first[:weight] + inws.first}
  1.upto(psubs.length - 1) do |i|
    curr = {:path => psubs[i][:path] + [v], 
            :weight => psubs[i][:weight] + inws[i]}
    best = curr if curr[:weight] > best[:weight]
  end
  best
end

# --- Coursera problem 6.5 - Global alignment problem ---------------------------------
def extend sol, nexta, nextb, weight_added
  {:s1 => sol[:s1] + [nexta], 
   :s2 => sol[:s2] + [nextb],
   :w => sol[:w] + weight_added,
   :step => sol[:step] + 1 }
end

def galign a, b, score, sigma
  mat = build_matrix(a.length + 1, b.length + 1)
  mat [0][0] = {:s1 => [], :s2 => [], :w => 0, :step => 0}
  1.upto(a.length) do |i| 
    mat[i][0] = extend(mat[i - 1][0], a[0], '-', -sigma)
  end
  1.upto(b.length) do |j| 
    mat[0][j] = extend(mat[0][j - 1], '-', b[0], -sigma)
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      # Delete/Down = '-' in A, Insert/Right = '-' in B
      sol1 = extend(mat[i - 1][j], a[i - 1], '-', -sigma)
      sol2 = extend(mat[i][j - 1], '-', b[j - 1], -sigma)
      sol3 = extend(mat[i - 1][j - 1], a[i - 1], b[j - 1], score[a[i - 1]][b[j - 1]])
      best = [sol1, sol2, sol3].reduce{|x,y| x[:w] > y[:w] ? x : y}
      mat[i][j] = best
    end
  end
  mat[a.length][b.length]
end

# --- Faster version -------------
def fast_galign a, b, score, sigma
  mat = build_matrix(a.length + 1, b.length + 1)
  mat [0][0] = 0
  1.upto(a.length) do |i| 
    mat[i][0] = mat[i - 1][0] - sigma
  end
  1.upto(b.length) do |j| 
    mat[0][j] = mat[0][j - 1] - sigma 
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] - sigma, 
              mat[i][j - 1] - sigma, 
              mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]]]
      best = sols.max        
      mat[i][j] = best
    end
  end
  #p mat[a.length][b.length] # ------ DEBUG
  s1 = []; s2 = []
  i = a.length; j = b.length
  while i > 0 or j > 0
    if i == 0 
      s1.insert(0, '-')
      s2.insert(0, b[j - 1])
      j -= 1
    elsif j == 0 
      s1.insert(0, a[i - 1])
      s2.insert(0, '-')
      i -= 1
    else
      sols = [mat[i - 1][j] - sigma, 
              mat[i][j - 1] - sigma, 
              mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]]]
      best = sols.max     
      if best == sols[0]
        s1.insert(0, a[i - 1])
        s2.insert(0, '-')
        i -= 1
      elsif best == sols[1]
        s1.insert(0, '-')
        s2.insert(0, b[j - 1])
        j -= 1
      else
        s1.insert(0, a[i - 1])
        s2.insert(0, b[j - 1])
        i -= 1
        j -= 1
      end
    end
  end
  {:s1 => s1, :s2 => s2, :w => mat[a.length][b.length]}
end

# --- Coursera problem 6.6 - Local alignment problem ----------------------------------
class Vertex
  attr_reader :vid, :total_weight, :best_in_edge
  attr_reader :in_edges
  
  def initialize pos
    @vid = pos
    @in_edges = []
    @total_weight = 0
  end 
  
  def add_edge_from vertex, s1, s2, weight_added
    @in_edges << Edge.new(vertex, s1, s2, weight_added)
  end
  
  def compute_total_weight
    @total_weight = nil if !@in_edges.empty?
    @in_edges.each do |e|
      v = e.weight_added + e.from.total_weight
      if !@total_weight or v > total_weight
        @total_weight = v
        @best_in_edge = e
      end
    end
  end
  
  def source?
    @in_edges.empty?
  end
  
  def best_path
    return [] if source?
    bpp = @best_in_edge.from.best_path
    bpp << {:s1 => @best_in_edge.s1, :s2 => @best_in_edge.s2, :w => @total_weight}
    bpp
  end
  
  def to_s
    s = ([@vid] + @in_edges.map{|e| e.from}).inspect
  end
  
end

class Edge
  attr_accessor :from, :s1, :s2, :weight_added
  
  def initialize frm, s1, s2, wa
    self.from = frm
    self.s1 = s1
    self.s2 = s2
    self.weight_added = wa
  end
end

def build_lalign_graph s1, s2, score_matrix, sigma
  vertices = {}
  first = Vertex.new([0, 0])
  first.compute_total_weight
  vertices[[0, 0]] = first
  last = Vertex.new([s1.length, s2.length])
  vertices[[s1.length, s2.length]] = last
  1.upto(s1.length) do |i|
    v = Vertex.new([i, 0])
    v.add_edge_from(vertices[[i - 1, 0]], s1[i - 1], '-', -sigma)
    v.add_edge_from(vertices[[0, 0]], '', '', 0)
    v.compute_total_weight
    vertices[[i, 0]] = v
    last.add_edge_from(v, '', '', 0)
  end
  1.upto(s2.length) do |j|
    v = Vertex.new([0, j])
    v.add_edge_from(vertices[[0, j - 1]], '-', s2[j - 1], -sigma)
    v.add_edge_from(vertices[[0, 0]], '', '', 0)
    v.compute_total_weight
    vertices[[0, j]] = v
    last.add_edge_from(v, '', '', 0)
  end
  1.upto(s1.length) do |i|
    1.upto(s2.length) do |j|
      v = Vertex.new([i, j])
      v.add_edge_from(vertices[[i - 1, j]], s1[i - 1], '-', -sigma)
      v.add_edge_from(vertices[[i, j - 1]], '-', s2[j - 1], -sigma)
      v.add_edge_from(vertices[[i - 1, j - 1]], s1[i - 1], s2[j - 1], score_matrix[s1[i - 1]][s2[j - 1]])
      v.add_edge_from(vertices[[0, 0]], '', '', 0) if [i, j] != [s1.length, s2.length]
      v.compute_total_weight
      vertices[[i, j]] = v
      last.add_edge_from(v, '', '', 0)
    end
  end
  last.compute_total_weight
  last
end

def lalign a, b, score, sigma
  sink = build_lalign_graph(a, b, score, sigma)
  path = sink.best_path
  s1 = path.map{|v| v[:s1]}
  s2 = path.map{|v| v[:s2]}
  w = sink.total_weight
  {:s1 => s1, :s2 => s2, :w => w}
end 


 # --- Faster version
def fast_lalign a, b, score, sigma
  mat = build_matrix(a.length + 1, b.length + 1, 0)
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] - sigma, 
              mat[i][j - 1] - sigma, 
              mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]],
              0]
      best = sols.max        
      mat[i][j] = best
    end
  end
  
  jumpdown = [a.length, b.length] 
  a.length.downto(0) do |i|
    b.length.downto(0) do |j|
      if [i, j] != [a.length, b.length] and [i, j] != [0, 0]
        if mat[i][j] > mat[a.length][b.length] 
          jumpdown = [i, j]
          mat[a.length][b.length] = mat[i][j] 
        end
      end
    end
  end
  
  s1 = []; s2 = []
  i, j = jumpdown
  while i > 0 and j > 0
    
    sols = [0,
            mat[i - 1][j] - sigma, 
            mat[i][j - 1] - sigma, 
            mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]]]
    best = sols.max   
    if best == sols[0]  
      i = 0; j = 0
    elsif best == sols[1]
      s1.insert(0, a[i - 1])
      s2.insert(0, '-')
      i -= 1
    elsif best == sols[2]
      s1.insert(0, '-')
      s2.insert(0, b[j - 1])
      j -= 1
    else
      s1.insert(0, a[i - 1])
      s2.insert(0, b[j - 1])
      i -= 1
      j -= 1
    end
  end
  {:s1 => s1, :s2 => s2, :w => mat[a.length][b.length]}
end

# --- Coursera problem 7.1 - Edit distance problem ------------------------------------
def edit_distance a, b
  mat = build_matrix(a.length + 1, b.length + 1)
  mat [0][0] = 0
  1.upto(a.length) do |i| 
    mat[i][0] = mat[i - 1][0] + 1
  end
  1.upto(b.length) do |j| 
    mat[0][j] = mat[0][j - 1] + 1 
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] + 1, 
              mat[i][j - 1] + 1, 
              mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1)]
      best = sols.min        
      mat[i][j] = best
    end
  end
  mat[a.length][b.length]
end

# --- Coursera problem 7.2 - Fitting alignment problem --------------------------------
def print_mat mat # NOTE: This is a debug function only.
  mat.each do |r| 
    puts r.map{|c| c >= 0 ? ' ' + c.to_s : c.to_s}.join(' ')
  end
end

def fitting_alignment a, b, match = 1, mismatch = 1
  mat = build_matrix(a.length + 1, b.length + 1)
  bt = build_matrix(a.length + 1, b.length + 1) #[i,j,s1,s2]
  0.upto(a.length) do |i| 
    mat[i][0] = 0
    bt[i][0] = (i == 0 ? [0, 0, '', ''] : [-1, 0, '', ''])
  end
  1.upto(b.length) do |j| 
    mat[0][j] = mat[0][j - 1] - mismatch 
    bt[0][j] = [0, -1, '&', '&']
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] - mismatch,
              mat[i][j - 1] - mismatch,
              mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? match : -mismatch)]
      best = sols.max        
      mat[i][j] = best
      if best == sols[0]
        bt[i][j] = [-1, 0, a[i-1], '-']
      elsif best == sols[1]
        bt[i][j] = [0, -1, '-', b[j-1]]
      else
        bt[i][j] = [-1, -1, a[i-1], b[j-1]]
      end
    end
  end
  #print_mat(mat)  # ---- DEBUG
  bestv = -mismatch * (a.length + b.length); ilast = a.length
  b.length.upto(a.length){|i| (ilast = i; bestv = mat[i][b.length]) if mat[i][b.length] > bestv}
  vp = []; wp = []
  i = ilast; j = b.length
  while i > 0 or j > 0
    idec, jdec, v, w = bt[i][j]
    vp.insert(0, v)
    wp.insert(0, w)
    i += idec
    j += jdec
  end
  {:vp => vp, :wp => wp, :w => mat[ilast][b.length]}
end

# --- Coursera problem 7.3 - Overlap alignment problem --------------------------------
def overlap_align a, b, match = 1, mismatch = 2
  mat = build_matrix(a.length + 1, b.length + 1)
  bt = build_matrix(a.length + 1, b.length + 1) #[i,j,s1,s2]
  0.upto(a.length) do |i| 
    mat[i][0] = 0
    bt[i][0] = (i == 0 ? [0, 0, '', ''] : [-1, 0, '', ''])
  end
  1.upto(b.length) do |j| 
    mat[0][j] = mat[0][j - 1] - mismatch 
    bt[0][j] = [0, -1, '&', '&']
  end
  badv = -mismatch * (a.length + b.length)
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      if i < a.length and j == b.length
        mat[i][j] = badv
        bt[i][j] = [-1, -1, '*', '*']
      else
        sols = [mat[i - 1][j] - mismatch,
                mat[i][j - 1] - (i == a.length ? 0 : mismatch),
                mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? match : -mismatch)]
        best = sols.max        
        mat[i][j] = best
        if best == sols[0]
          bt[i][j] = [-1, 0, a[i-1], '-']
        elsif best == sols[2]
          bt[i][j] = [-1, -1, a[i-1], b[j-1]]
        else
          i == a.length ? bt[i][j] = [0, -1, '', ''] : bt[i][j] = [0, -1, '-', b[j-1]]
        end
      end
    end
  end
  bestv = -mismatch * (a.length + b.length); ilast = a.length
  b.length.upto(a.length){|i| (ilast = i; bestv = mat[i][b.length]) if mat[i][b.length] > bestv}
  vp = []; wp = []
  i = ilast; j = b.length
  while i > 0 or j > 0
    idec, jdec, v, w = bt[i][j]
    vp.insert(0, v)
    wp.insert(0, w)
    i += idec
    j += jdec
  end
  {:s1 => vp, :s2 => wp, :w => mat[ilast][b.length]}
end

# --- Coursera problem 7.4 - Affine gap alignment problem --------------------------------
def affine_gap_align a, b, score, sigma = 1, epsilon = 1
  inf = 999999 * (sigma + epsilon) * (a.length + b.length)
  low = build_matrix(a.length + 1, b.length + 1)
  mid = build_matrix(a.length + 1, b.length + 1)
  up = build_matrix(a.length + 1, b.length + 1)
  low[0][0] = {:prev => nil, :w => -sigma, :s1 => '', :s2 => ''}
  up[0][0] = {:prev => nil, :w => -sigma, :s1 => '', :s2 => ''}
  mid[0][0] = {:prev => nil, :w => 0, :s1 => '', :s2 => ''}
  1.upto(a.length) do |i| 
   low[i][0] = {:prev => [:low, i-1, 0], :w => low[i-1][0][:w] - epsilon, :s1 => a[i-1], :s2 => '-'}
   up[i][0] = {:prev => [:up, i-1, 0], :w => -inf, :s1 => a[i-1], :s2 => '-'}
   mid[i][0] = {:prev => [:mid, i-1, 0], :w => -(sigma + ((i - 1) * epsilon)), :s1 => a[i-1], :s2 => '-'}
  end
  1.upto(b.length) do |j| 
   low[0][j] = {:prev => [:low, 0, j-1], :w => -inf, :s1 => '-', :s2 => b[j-1]}
   up[0][j] = {:prev => [:up, 0, j-1], :w => up[0][j-1][:w] - epsilon, :s1 => '-', :s2 => b[j-1]}
   mid[0][j] = {:prev => [:mid, 0, j-1], :w => -(sigma + ((j - 1) * epsilon)), :s1 => '-', :s2 => b[j-1]}
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      # low
     sols = [low[i-1][j][:w] - epsilon, mid[i-1][j][:w] - sigma]
     best = sols.max
     if best == sols[0]
       low[i][j] = {:prev => [:low, i-1, j], :w => best, :s1 => a[i-1], :s2 => '-'}
     else
       low[i][j] = {:prev => [:mid, i-1, j], :w => best, :s1 => a[i-1], :s2 => '-'}
     end
     
     # up
     sols = [up[i][j-1][:w]  - epsilon, mid[i][j-1][:w]  - sigma]
     best = sols.max
     if best == sols[0]
       up[i][j] = {:prev => [:up, i, j-1], :w => best, :s1 => '-', :s2 => b[j-1]}
     else
       up[i][j] = {:prev => [:mid, i, j-1], :w => best, :s1 => '-', :s2 => b[j-1]}
     end
     
     # mid
     sols = [low[i][j][:w] , up[i][j][:w] , mid[i-1][j-1][:w]  + score[a[i-1]][b[j-1]]]
     best = sols.max
     if best == sols[0]
       mid[i][j] = {:prev => [:low, i, j], :w => best, :s1 => '', :s2 => ''}
     elsif best == sols[1]
       mid[i][j] = {:prev => [:up, i, j], :w => best, :s1 => '', :s2 => ''}
     else
       mid[i][j] = {:prev => [:mid, i-1, j-1], :w => best, :s1 => a[i-1], :s2 => b[j-1]}
     end
    end
  end
  #p mat[a.length][b.length] # ------ DEBUG
  s1 = []; s2 = []
  m,n = a.length, b.length
  curr = [low[m][n], up[m][n], mid[m][n]].reduce{|x,y| x[:w] > y[:w] ? x : y}
  weight = curr[:w]
  mat = {:low => low, :up => up, :mid => mid}
  while curr
    s1.insert(0, curr[:s1])
    s2.insert(0, curr[:s2])
    if curr[:prev]
      m, i, j = curr[:prev]
      curr = mat[m][i][j]
    else
      curr = nil
    end
  end
  {:s1 => s1, :s2 => s2, :w => weight}
end

# --- Coursera problem 7.5 - Middle edge problem --------------------------------
def middle_edge a, b, score, sigma = 5
  mat = build_matrix(a.length + 1, b.length + 1)
  mat [0][0] = 0
  1.upto(a.length) do |i| 
    mat[i][0] = mat[i - 1][0] - sigma
  end
  1.upto(b.length) do |j| 
    mat[0][j] = mat[0][j - 1] - sigma 
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] - sigma, 
              mat[i][j - 1] - sigma, 
              mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]]]
      best = sols.max        
      mat[i][j] = best
    end
  end
  middle_right = (b.length / 2)
  #p mat[a.length][b.length] # ------ DEBUG
  i = a.length; j = b.length
  while j > middle_right#i > 0 or j > 0
    if i == 0 
      j -= 1
    elsif j == 0 
      i -= 1
    else
      sols = [mat[i - 1][j] - sigma, 
              mat[i][j - 1] - sigma, 
              mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]]]
      best = sols.max     
      if best == sols[0]
        i -= 1
      elsif best == sols[1]
        j -= 1
      else
        i -= 1
        j -= 1
      end
    end
  end
  [[i, j], [i + 1, j + 1]]
end

# --- Coursera problem 7.7 - Multiple longest common subsequences problem -------------
def build_3d_matrix d1, d2, d3, init = nil
  outer = []
  1.upto(d1) do
    mid = []
    1.upto(d2) do
      inner = []
      1.upto(d3){inner << init}
      mid << inner
    end
    outer << mid
  end
  outer
end

def mlcs a, b, c
  mat = build_3d_matrix(a.length + 1, b.length + 1, c.length + 1)
  mat[0][0][0] = {:prev => nil, :s1 => '', :s2 => '', :s3 => '', :w => 0}
  1.upto(a.length) do |i|
    mat[i][0][0] = {:prev => [i-1,0,0], :s1 => a[i-1], :s2 => '-', :s3 => '-', :w => 0}
    1.upto(b.length) do |j|
      mat[i][j][0] = {:prev => [i-1,j-1,0], :s1 => a[i-1], :s2 => b[j-1], :s3 => '-', :w => 0}
    end
    1.upto(c.length) do |k|
      mat[i][0][k] = {:prev => [i-1,0,k-1], :s1 => a[i-1], :s2 => '-', :s3 => c[k-1], :w => 0}
    end
  end
  1.upto(b.length) do |j|
    mat[0][j][0] = {:prev => [0,j-1,0], :s1 => '-', :s2 => b[j-1], :s3 => '-', :w => 0}
    1.upto(c.length) do |k|
      mat[0][j][k] = {:prev => [0,j-1,k-1], :s1 => '-', :s2 => b[j-1], :s3 => c[k-1], :w => 0}
    end
  end
  1.upto(c.length) do |k|
    mat[0][0][k] = {:prev => [0,0,k-1], :s1 => '-', :s2 => '-', :s3 => c[k-1], :w => 0}
  end
  
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      1.upto(c.length) do |k|
        sols = [mat[i-1][j][k][:w],
                mat[i][j-1][k][:w],
                mat[i][j][k-1][:w],
                mat[i-1][j-1][k][:w],
                mat[i-1][j][k-1][:w],
                mat[i][j-1][k-1][:w],
                mat[i-1][j-1][k-1][:w] + ((a[i-1] == b[j-1] and b[j-1] == c[k-1]) ? 1 : 0)]
        best = sols.max
        if best == sols[0]
          mat[i][j][k] = {:prev => [i-1,j,k], :s1 => a[i-1], :s2 => '-', :s3 => '-', :w => mat[i-1][j][k][:w]}
        elsif best == sols[1]
          mat[i][j][k] = {:prev => [i,j-1,k], :s1 => '-', :s2 => b[j-1], :s3 => '-', :w => mat[i][j-1][k][:w]}
        elsif best == sols[2]
          mat[i][j][k] = {:prev => [i,j,k-1], :s1 => '-', :s2 => '-', :s3 => c[k-1], :w => mat[i][j][k-1][:w]}
        elsif best == sols[3]
          mat[i][j][k] = {:prev => [i-1,j-1,k], :s1 => a[i-1], :s2 => b[j-1], :s3 => '-', :w => mat[i-1][j-1][k][:w]}
        elsif best == sols[4]
          mat[i][j][k] = {:prev => [i-1,j,k-1], :s1 => a[i-1], :s2 => '-', :s3 => c[k-1], :w => mat[i-1][j][k-1][:w]}  
        elsif best == sols[5]
          mat[i][j][k] = {:prev => [i,j-1,k-1], :s1 => '-', :s2 => b[j-1], :s3 => c[k-1], :w => mat[i][j-1][k-1][:w]}  
        else
          mat[i][j][k] = {:prev => [i-1,j-1,k-1], :s1 => a[i-1], :s2 => b[j-1], :s3 => c[k-1], 
                          :w => mat[i-1][j-1][k-1][:w] + (a[i-1] == b[j-1] and b[j-1] == c[k-1] ? 1 : 0)} 
        end 
        #p [[i,j,k], mat[]]
      end
    end
  end
  s1 = []; s2 = []; s3 = []
  curr = mat[a.length][b.length][c.length]
  weight = curr[:w]
  while curr
    s1.insert(0,curr[:s1])
    s2.insert(0,curr[:s2])
    s3.insert(0,curr[:s3])
    if curr[:prev]
      i,j,k = curr[:prev]
      curr = mat[i][j][k]
    else
      curr = nil
    end
  end
  {:s1 => s1, :s2 => s2, :s3 => s3, :w => weight}
end













