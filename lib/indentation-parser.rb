require "indentation-parser/node"
require "indentation-parser/hooks"
require "indentation-parser/handlers"

class IndentationParser

  def initialize    
    @node_handlers = {}
    @leaf_handlers = {}
    @child_of_handlers = {}
    yield self if block_given?
  end
  
  def parse_line line
    idx = line.index(/[^ ]/)
    return idx / 2, line[idx..line.length]
  end

  def read text, root_value
    root = IndentationParser::RootNode.new
    root.set_value root_value
    node_stack = [root]
    
    text.each_line do |line|
      line.chomp!
      next if line.length == 0 || line =~ /^\s*$/

      indentation, source = parse_line line
      new_node = IndentationParser::Node.new source, indentation
      previous_node = node_stack.last
      
      if new_node.indentation() - 1 == previous_node.indentation 
        #the current node is indented to the previous node
        handle_by_one_indentation previous_node, new_node, node_stack

      elsif new_node.indentation == previous_node.indentation 
        #the current node is on the same level as the previous node
        handle_same_indentation new_node, node_stack

      elsif new_node.indentation() - 1 > previous_node.indentation 
        #too large indentation -> raise an error
        raise "ou neei"

      else 
        #indentation is less than previous node. 
        #pop everything from stack until parent is found
        handle_less_indentation previous_node, new_node, node_stack
      end
    end
    handle_leaf node_stack.last
    root
  end

  def handle_by_one_indentation previous_node, new_node, node_stack
    previous_node.add new_node
    handle_node previous_node unless previous_node.is_a? RootNode
    node_stack.push new_node
  end

  def handle_same_indentation new_node, node_stack
    leaf = node_stack.pop
    handle_leaf leaf
    node_stack.last.add new_node
    node_stack.push new_node
  end

  def handle_less_indentation previous_node, new_node, node_stack
    leaf = node_stack.pop
    handle_leaf leaf
    (previous_node.indentation - new_node.indentation).times do 
      node_stack.pop          
    end
    node_stack.last.add new_node
    node_stack.push new_node
  end
end