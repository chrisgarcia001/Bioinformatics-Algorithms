while i > 0 and j > 0
    
    sols = [mat[i - 1][j] - sigma, 
            mat[i][j - 1] - sigma, 
            mat[i - 1][j - 1] + score[a[i - 1]][b[j - 1]],
            0]
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
  {:s1 => s1, :s2 => s2, :w => mat[a.length][b.length]}














def galign_costs a, b, i, j, mat, score, sigma
  if i == 0 or j == 0
    mat[i][j] = 0
  else
    galign_costs(a, b, i - 1, j, mat, score, sigma)
    galign_costs(a, b, i, j - 1, mat, score, sigma)
    galign_costs(a, b, i - 1, j - 1, mat, score, sigma)
    p1 = mat[i - 1][j] - sigma
    p2 = mat[i][j - 1] - sigma
    p3 = mat[i - 1][j - 1] + score[i][j]
    mat[i][j] = [p1, p2, p3].max
  end
end

def galign_b a, b, score, sigma
  mat = build_matrix(a.length + 1, b.length + 1)
  bcktrk = build_matrix(a.length, b.length)
  galign_costs(a, b, a.length, b.length, mat, score, sigma)
  mat[a.length][b.length]
end 



# Speed-up tips: http://www.ics.uci.edu/~eppstein/161/960229.html
def fast_lcs a, b
  mat = Array.new(a.length + 1, Array.new(b.length + 1))
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

# ------------------------------
# http://rosettacode.org/wiki/Longest_common_subsequence
class LcsWalker
  SELF, LEFT, UP, DIAG = [0,0], [0,-1], [-1,0], [-1,-1]
 
  def initialize(matrix); @m, @i, @j = matrix, 0, 0;        end 
  def valid?(i=@i, j=@j); i >= 0 && j >= 0;                 end
  def match(c, d);        @m[@i][@j] = compute_entry(c, d); end
  def pos(i, j);          @i, @j = i, j;                    end 
  def lookup(x, y);       [@i+x, @j+y];                     end 
 
  def peek(x, y)
    i, j = lookup(x, y)
    valid?(i, j) ? @m[i][j] : 0
  end 
 
  def compute_entry(c, d)
    c == d ? peek(*DIAG) + 1 : [peek(*LEFT), peek(*UP)].max
  end
 
  def backtrack
    Enumerator.new { |y| y << @i+1 if backstep while valid? }
  end
 
  def backstep
    backstep = compute_backstep
    @i, @j = lookup(*backstep)
    backstep == DIAG
  end
 
  def compute_backstep
    case peek(*SELF)
    when peek(*LEFT) then LEFT
    when peek(*UP)   then UP
    else                  DIAG
    end
  end
end

def lcsf(a, b)
  matrix = Array.new(a.length) { Array.new(b.length) }
  walker = LcsWalker.new(matrix)
 
  a.each_char.with_index do |x, i|
    b.each_char.with_index do |y, j|
      walker.pos(i, j)
      walker.match(x, y)
    end
  end
 
  walker.pos(a.length-1, b.length-1)
  walker.backtrack.inject("") { |s, i| s.prepend(a[i]) }
end
# ------------------------------
