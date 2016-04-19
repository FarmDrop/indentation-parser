class IndentationParser
  def call_handler block, node
    block.call(node.parent.value, node.source)
  end

  def execute_regex_handler node, regex, block
    captures = regex.match node.source
    if captures
      node_value = block.call(node.parent.value, node.source, captures)
      node.set_value node_value
      return true
    end
    false
  end

  def execute_child_of_handler node
    handler = @child_of_handlers[node.parent.value.class]
    if handler
      node_value = call_handler handler, node
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

  def handle_node node, leaf = false
    handled = execute_child_of_handler node
    return true if handled

    handled = try_to_handle @node_handlers, node
    return true if handled

    if leaf
      handled = handle_leaf node
    end

    return true if handled

    if @default
      node_value = call_handler @default, node if @default
      node.set_value node_value
      return true
    else
      return false
    end
  end

  def handle_leaf node
    handled = try_to_handle @leaf_handlers, node

    return true if handled

    if @on_leaf
      node_value = call_handler @on_leaf, node
      node.set_value node_value
      return true
    else
      return false
    end
  end
end
