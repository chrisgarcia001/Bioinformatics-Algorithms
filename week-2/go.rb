require 'util'
require 'algs'
require 'set'

include Util

mass_spec_table = {}
read_csv('mass_spec.txt', ' ').each do |pr| 
  mass_spec_table[pr[0]] = pr[1].to_i
end
aminos = mass_spec_table.values.map{|a| a.to_i}
args = read_args('tmp.txt', true).map{|a| a.to_i}
spec = args[1..args.length]
n = args[0]
#write('out.txt', pp(leaderboard_cyclopeptide_seq(args[1..args.length], aminos, args[0])))

#puts "Go"
data = nil
show_elapsed_time('LB') do
  #puts leaderboard_cyclopeptide_seq(spec, aminos, n)
  data = leaderboard_cyclopeptide_seq(spec, aminos, n)
end
write('out.txt', data)