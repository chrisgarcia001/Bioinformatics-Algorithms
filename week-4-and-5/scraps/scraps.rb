# Return nil if cycle 2 not contained in cycle 1
# Otherwise, appropriately insert cycle 2 inside of cycle 1.
def cycle_join cy1, cy2
  return cy1 + cy2 if cy1.empty? or cy2.empty?
  i = cy1.index(cy2[0])
  return nil if !i
  cyc = cy1.clone
  cyc[i] = cy2
  cyc.flatten
end

def merge_cycles cycles
  len = cycles.length
  prog = true
  while cycles.length > 1 and prog
    i = 0
    while i < cycles.length - 1
      j = i + 1
      while j < cycles.length
        a = cycles[i]
        b = cycles[j]
        m1 = cycle_join(a, b)
        m2 = cycle_join(b, a)
        if m1 or m2
          i = cycles.length
          j = cycles.length
          cycles.delete(a)
          cycles.delete(b)
          if m1
            cycles << m1
          else
            cycles << m2
          end
        end
        j += 1
      end
      i += 1
    end
    #p cycles.length
    if len >= cycles.length
      prog = false
    else
      len = cycles.length
    end
  end
  cycles#.first
end

def euler_cycle_o edges
  edges = edges.clone
  cycles = []
  while !edges.empty?
    start = edges.first[0]
    #edges.delete(start) if edges[start].length == 1
    nxt = nil
    curr = [start]
    while nxt != start and !edges.empty?
      out = edges[curr.last]
      nxt = out.pop
      edges.delete(curr.last) if out.empty?
      curr << nxt
    end
    cycles << curr if !curr.empty?
    p curr if curr.first != curr.last
  end
  merge_cycles(cycles)
  #cycles
end


#def all_bin_strings k
#  s = (0..k).to_a.map{|v| v.to_s(2)}
#  len = s.map{|v| v.length}.max
#  s.map do |v|
#    leading = Array.new(len - v.length, "0").join('')
#    leading + v
#  end
#end


def add_if_compatible pair, arr, i, d
  arr << nil
  l, r = pair.split('|').map{|s| s.split('')}
  if arr.empty?
    arr += l
    r.each_with_index{|c,j| arr.insert(i+r.length+j+d+1,c)}
    return arr
  else
    lp = arr[i..(i + l.length - 1)]
    rp = arr[(i+r.length+d+1)..(r.length)]
    #left_all = lp.all?{|x| x == }
  end
end

def add_if_compatible pair, arr, i, d
  l, r = pair.split('|').map{|s| s.split('')}
  if arr.empty?
    arr = Array.new(((l.length + 1)* 2) + d + 1, nil)
  else
    arr << nil
  end
  lc = arr[i..(i + l.length - 1)]
  rc = arr[(i + 1 + d)..(i + d + r.length)]
  lg, rg = true, true
  lc.each_with_index{|v,j| lg = (lg and (v == nil or v == l[j]))}
  rc.each_with_index{|v,j| rg = (rg and (v == nil or v == r[j]))}
  if lg and rg
    arr[]
  end
  nil
end


def expand v, i, d, edges, left_arr, right_arr
  out = edges[v]
  used = []
  while !out.empty?
    curr = out.pop
    l,r = curr.split('|').map{|x| x.split('')}
    if left_arr.empty? 
      left_arr = l
      right_arr = r
    elsif l.starts_with(left_arr[i..left_arr.length]) and r.starts_with(right_arr[i..right_arr.length])
      
    end
  end
end


def rp_compatible? v, d, i, arrs
  return true if arrs.empty?
  r, l = v
  #g1 = (starts_with?(l.reverse[1..l.length], arrs[0].reverse) and 
  #      starts_with?(r.reverse[1..r.length], arrs[1].reverse))
  if arrs[0].length + 1 < r.length + d + 1
    return true # g1
  else
    
  end
end



def expd v, edges, i, d, arrs, last
  return nil if !rp_compatible?(v, d, i, arrs)
  return nil if edges.empty? and v != last
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
    sol = expd(nv, edges, i + 1, d, rp_add(v, d, i, arrs), last)
    return sol if sol
    j += 1
  end
  edges[v] = out
  nil
end








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

def build_read_pairs path, d
  splits = path.map{|pair| pair.split('|')}
  k = splits[0][0].length + 1
  lhs = overlap_join(splits.map{|pr| pr[0]})
  rhs = overlap_join(splits.map{|pr| pr[1]})
  common = lhs[(k + d)..lhs.length]
  rem = rhs[lhs.length..rhs.length]
  #lhs + '-' + rhs
  lhs + rhs[(k + d)..rhs.length]
end

def reconstruct_read_pairs_o read_pairs, d, random_start = false
  edges = paired_debrujin_edges(read_pairs, false)
  build_read_pairs(euler_path(edges, random_start), d)
end


#---------------5.4 version 2----------------------------------------
def starts_with? a, b
  return false if a.length < b .length
  return a[0..(b.length - 1)] == b
end

def ends_with? a, b
  starts_with? a.reverse, b.reverse
end

# Assume each vertex v is a pair of kmers already parsed in form [["a,"b"],["c","d"]]
def rp_add_o v, d, i, arrs
  return v.clone if arrs.empty?
  #p arrs
  #p v
  [arrs[0] + [v[0].last], arrs[1] + [v[1].last]]
end

def rp_compatible_o? v, d, i, arrs
  return true if arrs.empty? or arrs[0].length <= v[0].length + d + 1
  arrs[1][arrs[0].length - v[0].length - d - 1] == v[0].last
end