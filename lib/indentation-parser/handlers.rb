class IndentationParser

  def execute_regex_handler node, regex, block
    captures = regex.match node.source
    if captures
      node_value = block.call(node.parent.value, node.indentation, node.source, captures)
      node.set_value node_value
      return true
    end
    false
  end
  
  def execute_child_of_handler node
    handler = @child_of_handlers[node.parent.value.class]
    if handler
      node_value = handler.call node.parent.value, node.indentation, node.source
      node.set_value node_value
      return true
    end
    false
  end

  def try_to_handle handlers, node
    handled = false
    handlers.each do |key, value|
      result = execute_regex_handler node, key, value
      handled = true if result      
    end
    handled
  end

  def handle_node node
    handled = execute_child_of_handler node
    
    return handled if handled
    
    handled = try_to_handle @node_handlers, node
    if not handled and @default
      node_value = @default.call node.parent.value, node.indentation, node.source if @default
      node.set_value node_value
    end
  end
  
  def handle_leaf node
    handled = try_to_handle @leaf_handlers, node
    if not handled and @on_leaf
      node_value = @on_leaf.call node.parent.value, node.indentation, node.source
      node.set_value node_value
    else
      handle_node node
    end
  end
  
end