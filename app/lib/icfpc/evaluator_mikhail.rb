require 'icfpc/functions'
require 'icfpc/tokenizer'

module ICFPC
  class EvaluatorMikhail
    class BinaryTree
      attr_accessor :root, :curent_node

      def initialize(token)
        @root = Node.new(token)
        @curent_node = @root
      end

      def find_parent_with_free_right
        # puts @curent_node.value.to_s
        node = @curent_node.parent
        while !node.right.nil?
          # puts node.value.to_s
          # puts node.right.value
          # puts '----'
          node = node.parent
          # puts node.value.to_s
          # puts node.right.value
          # puts '----'
          # exit
        end
        node
      end

      class Node
        attr_accessor :left, :right, :parent, :value

        def initialize(token)
          @value = token
          @left = nil
          @right = nil
          @parent = nil
        end

        def add_right(token)
          node = Node.new(token)
          node.parent = self
          @right = node
          node
        end

        def add_left(token)
          node = Node.new(token)
          node.parent = self
          @left = node
          node
        end
      end
    end

    Operator = Struct.new(:method_name, :arity, :infix)
    StackTraceElem = Struct.new(:function_name, :line, :token_num)
    PureFunction = Struct.new(:name, :assigned_at_line)

    OPERATORS = {
      '=' => Operator.new(:assign, arity: 2, infix: true),
      'ap' => Operator.new(:apply, arity: 2, infix: false)
    }

    def initialize()
      @stacktrace = []
      @pure_functions = {}
    end

    def execute(text, tokenizer = Tokenizer.new)
      text.each_line.with_index do |line, index|
        tokens = tokenizer.tokenize(line.strip)
        parsed_tree = parse(tokens, index + 1)

        pp ['tree', parsed_tree]
      end
    end

    def assign()
      raise NotImplemented
    end

    def apply
      raise NotImplemented
    end

    private

    def parse(tokens, line_num)
      tree = nil
      tokens.each_with_index do |token, index|
        if tree.nil?
          tree = BinaryTree.new(token)
        else
          if token.first == :primitive
            node = tree.find_parent_with_free_right
            r_node = node.add_right token
            tree.curent_node = r_node
          else
            l_node = tree.curent_node.add_left token
            tree.curent_node = l_node
          end
        end
      end
      tree
    end

    def add_infix_arg(token, stack)
      arg = stack.pop
      raise "There is no argument in stack"

      stack.push(stack.push([token, arg]))
    end
  end
end
