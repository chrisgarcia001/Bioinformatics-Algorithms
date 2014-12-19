require 'util'
require 'algs'
require 'set'

include Util

def writef sink, graph, outfile
  show_elapsed_time('Longest DAG Path') do
    soln = lp_dag(sink, graph[:edges])
    write(outfile, soln[:weight].to_s + "\n" + soln[:path].join('->'))
  end
end

infile = 'data/p4.txt'
outfile = 'data/out4.txt'

data = read_lines(infile)
sink = data[1]
graph = build_graph(data[2..data.length])
#p lp_dag(graph[:sinks].first, graph[:edges])
writef sink, graph, outfile

