class IndentationParser
  def on regex, &block    
    @node_handlers[regex] = block
  end

  def default &block
    @default = block
  end

  alias :else :default

  def on_leaf regex, &block
    @leaf_handlers[regex] = block
  end

  def on_leaf &block
    @on_leaf = block
  end  
  
  def as_a_child_of parent_node, &block
    
  end
end