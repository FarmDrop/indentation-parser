require "indentation-parser/version"
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
      
      lastone = node_stack.last
      
      if new_node.indentation() - 1 == lastone.indentation #the current node is indented to the previous node
        lastone.add new_node
        handle_node lastone unless lastone.is_a? RootNode
        node_stack.push new_node
      elsif new_node.indentation == lastone.indentation #the current node is on the same level as the previous node
        leaf = node_stack.pop
        handle_leaf leaf
        node_stack.last.add new_node
        node_stack.push new_node
      elsif new_node.indentation() - 1 > lastone.indentation #too large indentation -> raise an error
        raise "ou neei"
      else #indentation is less than previous node. Pop everything from stack until parent is found
        leaf = node_stack.pop
        handle_leaf leaf
        (lastone.indentation - new_node.indentation).times do 
          node_stack.pop          
        end
        node_stack.last.add new_node
        node_stack.push new_node
      end
    end
    handle_leaf node_stack.last
    root
  end
end