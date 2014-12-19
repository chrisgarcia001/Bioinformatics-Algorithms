module Util
  
  # Pretty-print an array
  def pp array
    array.map{|x| x.to_s}.join(' ')
  end
  
  def read(filename) 
    data = ''
    File.open(filename, "r") do |infile|      
      while (line = infile.gets)
        data << line
      end
    end
    data
  end
  
  def read_args(filename)
    read(filename).sub("\n", ' ').split(' ')
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