def min_cut(nodes, edges, size = nodes.length)
  return edges if size == 2
  node1, node2 = edges.sample
  nodes[node2][:edges].each do |e|
    e[0] = node1 if e[0] == node2
    e[1] = node1 if e[1] == node2
  end
  nodes[node1][:edges] = (nodes[node1][:edges] + nodes[node2][:edges]).reject {|e| e[0] == e[1]}
  return min_cut(nodes, edges.reject {|e| e[0] == e[1]}, size-1) 
end

def build_edges(data)
  data.map do |d|
    node, *others = *(d.strip.split(/\s+/).map(&:to_i).map{|x| x-1})
    others.map(&:to_i).reject {|on| on < node}.map {|on| [node, on]}
  end.flatten(1)
end  

def build_graph(data)
  edges = build_edges data
  nodes = (1..40).map {|i| {:edges => []}}
  edges.each do |e|
    nodes[e[0]][:edges].push(e)
    nodes[e[1]][:edges].push(e)
  end
  [nodes, edges]  
end  

data = File.read('kargerAdj.txt').split("\n")
min_cuts = (1..10000).map do |i| 
  nodes, edges = build_graph(data)
  min_cut(nodes, edges).length
end  
puts min_cuts.inspect
puts min_cuts.min
