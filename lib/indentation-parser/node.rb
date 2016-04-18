class IndentationParser
  class Node
    def initialize source, indentation
      @source = source
      @indentation = indentation
      @subnodes = []
      @stop_indentation = false
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
end
