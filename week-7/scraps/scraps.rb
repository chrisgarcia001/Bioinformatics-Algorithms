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

def sp seq
  return ['-', []] if seq.empty? 
  [seq[0], seq[1..seq.length]]
end 

def mlcs a, b, c, i, j, k, subs = {}
  #return [0, [], [], []] if a.empty? and b.empty? and c.empty?
  return subs[[i,j,k]] if subs.has_key?([i,j,k])
  r1 = mlcs(a)

end

# --- Coursera problem 7.4 - Affine gap alignment problem --------------------------------
def affine_gap_align a, b, score, sigma = 1, epsilon = 1
  mat = build_matrix(a.length + 1, b.length + 1)
  mat [0][0] = 0
  bt = {}
  1.upto(a.length) do |i| 
    mat[i][0] = mat[i - 1][0] - sigma
    bt[[i,0]] = {:s1 => a[i-1], :s2 => '-', :prev => [i-1,0]}
  end
  1.upto(b.length) do |j| 
    mat[0][j] = mat[0][j - 1] - sigma 
    bt[[0,j]] = {:s1 => '-', :s2 => b[j-1], :prev => [0, j-1]}
  end
  ia = false; ib = false
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      penalty_a = (ia ? epsilon : sigma)
      penalty_b = (ib ? epsilon : sigma)
      sols = [mat[i - 1][j] - penalty_a, 
              mat[i][j - 1] - penalty_b, 
              mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]]]
      best = sols.max        
      if best == sols[0]
        ia = true; ib = false
        bt[[i,j]] = {:s1 => a[i-1], :s2 => '-', :prev => [i-1,j]}
      elsif best == sols[1]
        ia = false; ib = true
        bt[[i,j]] = {:s1 => '-', :s2 => b[j-1], :prev => [i, j-1]}
      else
        ia = false; ib = false
        bt[[i,j]] = {:s1 => a[i-1], :s2 => b[j-1], :prev => [i-1, j-1]}
      end
      mat[i][j] = best
    end
  end
  #p mat[a.length][b.length] # ------ DEBUG
  s1 = []; s2 = []
  curr = bt[[a.length, b.length]]
  while curr
    s1.insert(0, curr[:s1])
    s2.insert(0, curr[:s2])
    ni, nj = curr[:prev]
    curr = bt[[ni,nj]]
  end
  {:s1 => s1, :s2 => s2, :w => mat[a.length][b.length]}
end

# --- Coursera problem 7.4 - Affine gap alignment problem --------------------------------
def affine_gap_align a, b, score, sigma = 1, epsilon = 1
  low = build_matrix(a.length + 1, b.length + 1)
  mid = build_matrix(a.length + 1, b.length + 1)
  up = build_matrix(a.length + 1, b.length + 1)
  bt = {} #[matrix, i, j] => [matrix, idec, jdec, s1, s2]  
  badv = -999999 * (sigma + epsilon) * (a.length + b.length)
  low[0][0] = -sigma
  up[0][0] = -sigma
  mid[0][0] = 0
  1.upto(a.length) do |i| 
    low[i][0] = low[i-1][0] - epsilon #(i == 1 ? -sigma : low[i-1][0] - epsilon)
    mid[i][0] = -(sigma + ((i - 1) * epsilon))
    up[i][0] = badv
    bt[[0, i, 0]] = [0, -1, 0, a[i-1], '-', low[i][0]]
    bt[[1, i, 0]] = [0, -1, 0, a[i-1], '&', mid[i][0]]
    bt[[2, i, 0]] = [0, -1, 0, a[i-1], '*', up[i][0]]
  end
  1.upto(b.length) do |j|
    low[0][j] = badv
    mid[0][j] = -(sigma + ((j - 1) * epsilon))
    up[0][j] = up[0][j-1] - epsilon #(j == 1 ? -sigma : up[0][j-1] - epsilon)
    bt[[2, 0, j]] = [2, 0, -1, '-', b[j-1], up[0][j]]
    bt[[1, 0, j]] = [2, 0, -1, '!', b[j-1], mid[0][j]]
    bt[[0, 0, j]] = [2, 0, -1, '@', b[j-1], low[0][j]]
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      # -- Low
      sols_low = [low[i-1][j] - epsilon,
                  mid[i-1][j] - sigma]
      best = sols_low.max
      low[i][j] = best
      if best == sols_low[0]
        bt[[0, i, j]] = [0, -1, 0, a[i-1], '-', best]
      else
        bt[[0, i, j]] = [1, -1, 0, a[i-1], '-', best]
      end
      # -- Up
      sols_up =  [mid[i][j-1] - sigma,
                  up[i][j-1] - epsilon]  
      best = sols_up.max
      up[i][j] = best
      if best == sols_up[0]
        bt[[2, i, j]] = [1, 0, -1, '-', b[j-1], best]
      else
        bt[[2, i, j]] = [2, 0, -1, '-', b[j-1], best]
      end 
      # -- Mid
      sols_mid = [low[i][j],
                  mid[i-1][j-1] + score[a[i-1]][b[j-1]],
                  up[i][j]]
      best = sols_mid.max
      mid[i][j] = best
      if best == sols_mid[1]
        bt[[1, i, j]] = [0, -1, 0, a[i-1], b[j-1], best]
      elsif best == sols_mid[0]
        bt[[1, i, j]] = [1, -1, -1, '', '', best]
      else 
        bt[[1, i, j]] = [2, 0, -1, '', '', best]
      end                                             
    end
  end
  best = [0,1,2].map{|v| bt[[v, a.length, b.length]]}.reduce{|x,y| x[5] > y[5] ? x : y}
  curr = best
  s1 = []; s2 = []
  i = a.length; j = b.length
  while (i > 0 or j > 0) #and curr
    #p curr
    mat, idec, jdec, v, w, cost = curr
    #p [mat,i,j]
    #p bt[curr[0..2]]  # ---- DEBUG
    s1.insert(0, v)
    s2.insert(0, w)
    # p i; p idec  # ---- DEBUG
    i += idec
    j += jdec
    #p [mat, i, j]
    curr = bt[[mat, i, j]]
  end
  {:s1 => s1, :s2 => s2, :w => best[5]}
end


# --- Coursera problem 7.4 - Affine gap alignment problem --------------------------------
def affine_gap_align_o a, b, score, sigma = 1, epsilon = 1
  low = build_matrix(a.length + 1, b.length + 1, 0)
  mid = build_matrix(a.length + 1, b.length + 1, 0)
  up = build_matrix(a.length + 1, b.length + 1, 0)
  bt = {} #[matrix, i, j] => [matrix, idec, jdec, s1, s2]  
  low[0][0] = -sigma
  bt[[0, 0, 0]] = [0, 0, 0, '#', '#', -sigma]
  up[0][0] = -sigma
  bt[[2, 0, 0]] = [2, 0, 0, '#', '#', -sigma]
  mid[0][0] = 0
  bt[[1, 0, 0]] = [2, 0, 0, '#', '#', 0]
  1.upto(a.length) do |i| 
    low[i][0] = low[i-1][0] - epsilon
    bt[[0, i, 0]] = [0, -1, 0, a[i-1], '-', low[i][0]]
  end
  1.upto(b.length) do |j| 
    up[0][j] = up[0][j-1] - epsilon
    bt[[2, 0, j]] = [2, 0, -1, '-', b[j-1], up[0][j]]
  end
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      # -- Low
      sols_low = [low[i-1][j] - epsilon,
                  mid[i-1][j] - sigma]
      best = sols_low.max
      low[i][j] = best
      if best == sols_low[0]
        bt[[0, i, j]] = [0, -1, 0, a[i-1], '-', best]
      else
        bt[[0, i, j]] = [1, -1, 0, a[i-1], '-', best]
      end
      # -- Up
      sols_up =  [mid[i][j-1] - sigma,
                  up[i][j-1] - epsilon]  
      best = sols_up.max
      up[i][j] = best
      if best == sols_low[0]
        bt[[2, i, j]] = [1, 0, -1, '-', b[j-1], best]
      else
        bt[[2, i, j]] = [2, 0, -1, '-', b[j-1], best]
      end 
      # -- Mid
      sols_mid = [low[i][j],
                  mid[i-1][j-1] + score[a[i-1]][b[j-1]],
                  up[i][j]]
      best = sols_mid.max
      mid[i][j] = best
      if best == sols_mid[0]
        bt[[1, i, j]] = [0, -1, 0, '&', '&', best]
      elsif best == sols_mid[1]
        bt[[1, i, j]] = [1, -1, -1, a[i-1], b[j-1], best]
      else 
        bt[[1, i, j]] = [2, 0, -1, '*', '*', best]
      end                                             
    end
  end
  best = [0,1,2].map{|v| bt[[v, a.length, b.length]]}.reduce{|x,y| x[5] > y[5] ? x : y}
  curr = best
  s1 = []; s2 = []
  i = a.length; j = b.length
  while (i > 0 or j > 0) and curr
    p curr
    mat, idec, jdec, v, w, cost = curr
    p [mat,i,j]
    #p bt[curr[0..2]]  # ---- DEBUG
    s1.insert(0, v)
    s2.insert(0, w)
    # p i; p idec  # ---- DEBUG
    i += idec
    j += jdec
    curr = bt[[mat, i, j]]
  end
  {:s1 => s1, :s2 => s2, :w => best[5]}
end



def prefix arr, n
  return [] if n == 0
  arr[0..(n - 1)]
end

def suffix arr, n
  arr[(arr.length - n)..arr.length]
end

# --- Coursera problem 7.2 - Fitting alignment problem --------------------------------
def prefix arr, n
  return [] if n == 0
  arr[0..(n - 1)]
end

def suffix arr, n
  arr[(arr.length - n)..arr.length]
end

def overlap_align a, b, mismatch = 2
  chars = Set.new(a + b)
  score = {}
  chars.each do |c1| 
    score[c1] = {}
    chars.each{|c2| c1 == c2 ? score[c1][c2] = 1 : score[c1][c2] = -mismatch}
  end
  best = nil
  i = 1
  minv = [a.length, b.length].min
  while (best ? best[:w] < (minv - i) : true) and i < minv
    s1 = suffix(a, i)
    s2 = prefix(b, i)
    #p [i, s1, s2]  # ----- DEBUG ---------
    curr = fast_galign(s1, s2, score, mismatch)
    if !best or curr[:w] >= best[:w]
      best = curr 
      best[:i] = i
    end
    i += 1
  end
  s1 = a.clone; s2 = b.clone
  1.upto(b.length - best[:i]){s1 << '-'}
  1.upto(a.length - best[:i]){s2.insert(0, '-')}
  {:s1 => s1, :s2 => s2, :w => best[:w]}
end


# --- Coursera problem 7.2 - Fitting alignment problem --------------------------------
def fast_overlap_align_o a, b, match = 1, mismatch = 2
  mat = build_matrix(a.length + 1, b.length + 1, 0)
  #0.upto(a.length){|i| mat[i][0] = 0}
  badv = -mismatch * [a.length, b.length].max
  1.upto(b.length){|j| mat[0][j] = badv}
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? match : -mismatch),
             (i == a.length ? mat[i][j - 1] : badv)]
      best = sols.max        
      mat[i][j] = best
    end
  end
  mat[a.length][b.length] # ------ DEBUG
  #p mat
  vp = []; wp = []
  i = a.length; j = b.length
  while i > 0 or j > 0
    if j == 0
      vp.insert(0, a[i - 1])
      wp.insert(0, '-')
      i -= 1
    else
      sols = [mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? match : -mismatch),
              (i == a.length ? mat[i][j - 1] : badv)]
      best = sols.max 
      if best == sols[0]
        vp.insert(0, a[i - 1])
        wp.insert(0, b[j - 1])
        i -= 1; j -= 1
      else
        vp.insert(0, '-')
        wp.insert(0, b[j - 1])
        j -= 1
      end
    end
  end
  {:first => vp, :second => wp, :w => mat[a.length][b.length]}
end

def fast_overlap_align a, b, match = 1, mismatch = 2
  i = 1
  best = nil
  while i < [a.length, b.length].min
    aa = suffix(a, i)
    bb = prefix(b, i)
    weight = 0
    aa.each_with_index do |v, j|
      v == bb[j] ? weight += match : weight -= mismatch
    end
    if !best or weight > best[:w]
      best = {:index => i, :w => weight}
    end
    i += 1
  end 
  s1 = a.clone; s2 = b.clone
  1.upto(b.length - best[:index]){s1 << '-'}
  1.upto(a.length - best[:index]){s2.insert(0, '-')}
  {:first => s1, :second => s2, :w => best[:w]}
end






# --- Coursera problem 7.2 - Fitting alignment problem --------------------------------
def fitting_alignment a, b
  mat = build_matrix(a.length + 1, b.length + 1, 0)
  #0.upto(a.length){|i| mat[i][0] = 0}
  #1.upto(b.length){|j| mat[0][j] = -b.length}
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] - (j == b.length ? 0 : 1), 
              mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 1 : -1)]
      best = sols.max        
      mat[i][j] = best
    end
  end
  #mat[a.length][b.length] # ------ DEBUG
  p mat
  vp = []; wp = []
  i = a.length; j = b.length
  while i > 0 and j > 0
    sols = [mat[i - 1][j] - (j == b.length ? 0 : 1),
            mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 1 : -1)]
    best = sols.max 
    if best == sols[0]
      if j < b.length
        vp.insert(0, a[i - 1])
        wp.insert(0, '-')
      end
      i -= 1
    else
      vp.insert(0, a[i - 1])
      wp.insert(0, b[j - 1])
      i -= 1
      j -= 1
    end
  end
  {:vp => vp, :wp => wp, :w => mat[a.length][b.length]}
end

# V3
def fitting_alignment a, b
  mat = build_matrix(a.length + 1, b.length + 1)
  0.upto(a.length){|i| mat[i][0] = 0}
  #1.upto(b.length){|j| mat[0][j] = -b.length}
  1.upto(b.length){|j| mat[0][j] = mat[0][j - 1] - 1}
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] + (j == b.length ? 0 : -1), 
              mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 1 : -1)]
      best = sols.max        
      mat[i][j] = best
    end
  end
  #print_mat(mat)
  vp = []; wp = []
  i = a.length; j = b.length
  prev = 1; curr = nil
  while i > 0 and j > 0
    sols = [mat[i - 1][j] + (j == b.length ? 0 : -1),
            mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 1 : -1)]
    best = sols.max 
    if sols[0] == sols[1]
      if prev == 0
        curr = 0
      else
        curr = 1
      end
    end
    if curr == 0 or best == sols[0] 
      if j < b.length
        vp.insert(0, a[i - 1])
        wp.insert(0, '-')
      end
      i -= 1
      curr == nil
    else
      vp.insert(0, a[i - 1])
      wp.insert(0, b[j - 1])
      i -= 1
      j -= 1
      curr = nil
    end
  end
  {:vp => vp, :wp => wp, :w => mat[a.length][b.length]}
end

def fitting_alignment a, b
  mat = build_matrix(a.length + 1, b.length + 1, 0)
  #0.upto(a.length){|i| mat[i][0] = 0}
  #1.upto(b.length){|j| mat[0][j] = -b.length}
  1.upto(a.length) do |i|
    1.upto(b.length) do |j|
      sols = [mat[i - 1][j] - (j == b.length ? 0 : 1), 
              mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 1 : -1)]
      best = sols.max        
      mat[i][j] = best
    end
  end
  #mat[a.length][b.length] # ------ DEBUG
  #p mat
  vp = []; wp = []
  i = a.length; j = b.length
  while i > 0 and j > 0
    sols = [mat[i - 1][j] - (j == b.length ? 0 : 1),
            mat[i - 1][j - 1] + (a[i - 1] == b[j - 1] ? 1 : -1)]
    best = sols.max 
    if sols[0] == sols[1] or best == sols[1]
      vp.insert(0, a[i - 1])
      wp.insert(0, b[j - 1])
      i -= 1
      j -= 1
    else
      if j < b.length
        vp.insert(0, a[i - 1])
        wp.insert(0, '-')
      end
      i -= 1
    end
  end
  {:vp => vp, :wp => wp, :w => mat[a.length][b.length]}
end

# -------------------
def edit_distance a, b
  chars = Set.new
  (a + b).each{|c| chars << c}
  score = {}
  chars.each do |c1| 
    score[c1] = {}
    chars.each{|c2| c1 == c2 ? score[c1][c2] = 1 : score[c1][c2] = 0}
  end
  sol = fast_galign(a, b, score, 1)
  ed = 0
  sol[:s1].each_with_index{|v, i| ed += 1 if v != sol[:s2][i]}
  ed
end


# -------------------
def fitting_alignment v, w
  best_score = -w.length; best_sol = []; best_pos = nil
  i = 0
  while i + w.length - 1 < v.length
    if v[i] == w[0]
      tsol = []; tscore = 0; tpos = i
      j = 0; found = 0
      while i + j < v.length and found < w.length
        if v[i + j] == w[j]
          tsol << w[j]
          found += 1
          tscore += 1
        else
          tsol << '-'
          tscore -= 1
        end
        j += 1
      end
      if found == w.length and tscore > best_score
        best_score = tscore
        best_sol = tsol
        best_pos = tpos
      end
    end
    i += 1
  end
  p best_sol
  #{:v => v[best_pos..(best_pos + best_sol.length - 1)], :w => best_sol, :score => best_score}
end