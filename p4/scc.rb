class DFS
  def initialize(vertices)
    @vertices = vertices
  end
  
  def search(options)
    visited = {}
    stack = []
    visited_callback = 
    completed_callback = options[:completed_callback]
    order = options[:order]
    if (!order) 
      order = (@vertices.size-1).downto(1)
      get_vertex = lambda {|i| @vertices[i]}
    else
      get_vertex = lambda {|label| vertex(label)}
    end
         
    order.each do |i|
      cur_node = get_vertex.call(i)
      next if visited[cur_node]
      
      visited[cur_node] = true
      options[:visited_callback].call(cur_node) if options[:visited_callback]
      stack.push(cur_node)

      until stack.empty?
        node = stack.last
        new_nodes_exist = false
        node[options[:direction]].each do |e|
          head_node = vertex(e)
          next if visited[head_node]
          
          visited[head_node] = true
          options[:visited_callback].call(head_node) if options[:visited_callback]
          stack.push(head_node)
          new_nodes_exist = true
        end  
        unless new_nodes_exist
          options[:completed_callback].call(stack.pop)
        end  
      end  
    end   
  end
  
  def vertex(label)
    @vertices[label - 1]
  end  
  
  def visit(node, direction)
    return if @visited[node]
    @visited[node] = true
    @visited_callback.call(node) if @visited_callback
    node[direction].each do |e|
      visit(vertex(e), direction)
    end    
    @completed_callback.call(node) if @completed_callback
  end      
end  


def create_vertex(label)
 {label: label, out_edges: [], in_edges: []}
end  

def build_graph(data)
  vertices = []
  data.each do |d|
    v1, v2 = d.split(' ').map(&:to_i)
    vertex_1 = vertices[v1-1] || create_vertex(v1)
    vertex_1[:out_edges].push(v2)
    vertices[v1-1] = vertex_1

    vertex_2 = vertices[v2-1] || create_vertex(v2)
    vertex_2[:in_edges].push(v1)
    vertices[v2-1] = vertex_2
  end
  vertices
end

data = File.read('SCC.txt').split("\n")
vertices = build_graph(data)
dfs = DFS.new(vertices)
finish_stack = []
dfs.search :direction => :in_edges, :visited_callback => nil, :completed_callback => lambda { |node| finish_stack.push(node[:label])}

leaders = Hash.new {|hash, key| hash[key] = []}
current_leader = nil
dfs.search :direction => :out_edges, :order => finish_stack.reverse_each, :visited_callback => 
  lambda {|node| current_leader = node[:label] unless current_leader}, :completed_callback => 
  lambda { |node| 
    leaders[current_leader].push(node[:label])
    current_leader = nil if node[:label] == current_leader
  }  

puts leaders.values.map(&:size).sort.inspect