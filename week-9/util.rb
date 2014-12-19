module Util
  
  # Pretty-print an array
  def pp array, sep = ' '
    array.map{|x| x.to_s}.join(sep)
  end
  
  def read(filename, ignore_line_ends = true) 
    data = ''
    File.open(filename, "r") do |infile|      
      while (line = infile.gets)
        if ignore_line_ends
          data << line.strip
        else
          data << line.strip + ' '
        end
      end
    end
    data
  end
  
  def read_lines(filename) 
    data = []
    File.open(filename, "r") do |infile|      
      while (line = infile.gets)
        data << line.strip
      end
    end
    data
  end
  
  def read_args(filename, ignore_line_ends = true)
    read(filename, ignore_line_ends).split(' ') 
  end
  
  def read_csv(filename, sep = ',')
    data = []
    File.open(filename, "r") do |infile|      
      while (line = infile.gets)
        data << line.delete("\n").split(sep)
      end
    end
    data
  end
  
  def write filename, data
    File.open(filename, 'w') do |f|  
      f.puts data
    end  
  end
  
  def show_elapsed_time msg, &block
    puts '----------------------------------------'
    puts  'Timing: ' + msg.to_s
    start_time = Time.now
    block.call
    elapsed = Time.now - start_time
    puts 'Elapsed Time: ' + elapsed.to_s
    puts '----------------------------------------'; puts ''
  end
  
  def freq_table array
    h = {}
    array.each do |v|
      h[v] = 0 if !h[v]
      h[v] += 1
    end
    h
  end
  
  def compare(arr1, arr2)
    f1 = freq_table(arr1)
    f2 = freq_table(arr2)
    fa = {}; fb = {}
    f1.each{|k,v| fa[k] = f1[k] - (f2[k] || 0) if f1[k] != f2[k]}
    f2.each{|k,v| fb[k] = f2[k] - (f1[k] || 0) if f2[k] != f1[k]}
    puts 'Mismatches in A1: ' + fa.inspect
    puts ''
    puts 'Mismatches in A2: ' + fb.inspect
  end
  
  def diff_comp a1, a2
    0.upto([a1.length, a2.length].max) do |i|
      puts('i =' + i.to_s + ' a1=' + a1[i].to_s + ' a2 =' + a2[i].to_s) if a1[i] != a2[i]
    end
  end
  
  def score_matrix filename
    lines = read_lines(filename)
    lines[0] = '- ' + lines[0]
    matrix = {}
    col_heads = lines[0].split(' ')
    1.upto(lines.length - 1) do |i|
      line = lines[i].split(' ')
      row = {}
      1.upto(line.length - 1) do |j|
        row[col_heads[j]] = line[j].to_i 
      end
      matrix[line[0]] = row
    end
    matrix
  end
end