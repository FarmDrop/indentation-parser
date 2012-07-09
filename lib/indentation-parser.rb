require "indentation-parser/version"

class IndentationParser

  class Node
    def initialize source, indentation
      @source = source
      @indentation = indentation
      @subnodes = []
    end
    def add node
      node.set_parent self
      @subnodes << node
    end  
    def parent
      @parent
    end
    def set_parent parent
      @parent = parent
    end
    def indentation
      @indentation
    end
    def source
      @source
    end
    def value
      @value
    end
    def set_value value
      @value = value
    end
  end
  
  class RootNode < Node
    def initialize
      super "root", -1
    end
  end
  
  def initialize
    @handlers = {}
    yield self
  end
  
  def parse_line line
    idx = line.index(/[^ ]/)
    return idx / 2, line[idx..line.length]
  end

  def handle_node node
    @handlers.each do |key, value|
      captures = key.match node.source
      if captures
        node_value = value.call(node.parent.value, node.indentation, node.source, captures)
        node.set_value node_value
        return
      end
    end
    node_value = @else.call node.parent.value, node.indentation, node.source if @else
    node.set_value node_value
  end
  
  def handle_leaf node
    if @on_leaf
      node_value = @on_leaf.call node.parent.value, node.indentation, node.source
      node.set_value node_value
    else
      handle_node node
    end
  end

  def on regex, &block
    @handlers[regex] = block
  end

  def else &block
    @else = block
  end

  def on_leaf &block
    @on_leaf = block
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