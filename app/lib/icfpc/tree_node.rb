module ICFPC
  class TreeNode
    attr_reader :value, :children

    attr_accessor :meta, :parent

    def initialize(value, parent: nil, meta: nil)
      @value = value
      @parent = parent
      unless parent.nil?
        @parent.children.push(self)
      end
      @children = []
      @meta = meta
    end

    def add_child(value)
      new_node = TreeNode.new(value)
      @children.push(new_node)
      new_node.parent = self

      new_node
    end

    def get_root
      cur_node = self
      while !cur_node.parent.nil?
        cur_node = cur_node.parent
      end

      cur_node
    end
  end
end