module Util
  
  # Pretty-print an array
  def pp array
    array.map{|x| x.to_s}.join(' ')
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
  
  
end