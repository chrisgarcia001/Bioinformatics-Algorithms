require 'util'
require 'algs'
require 'set'

include Util

def format_solution sol
  sol.map{|line| "(#{line.map{|x| x < 0 ? x.to_s : '+' + x.to_s}.join(' ')})"}.join("\n")
end

def format_input str
  str[1..(str.length - 2)].split(' ').map{|x| x.to_i}
end

def print_sol input_string
  puts format_solution(greedy_sort(format_input(input_string)))
end

def writef input_string, outfile
  show_elapsed_time('Greedy Sorting') do
    sol = greedy_sort(format_input(input_string))
    data = format_solution(sol)
    write(outfile, data)
  end  
end

infile = 'data/p1.txt'
outfile = 'data/out1.txt'
#1, s2 = read_lines(infile)
#p format_input('(-3 +4 +1 +5 -2)')
#puts format_solution(greedy_sort([-3, 4, 1, 5, -2]))
print_sol '(-3 +4 +1 +5 -2)'
input_string = read_lines(infile)[0]
writef(input_string, outfile)


